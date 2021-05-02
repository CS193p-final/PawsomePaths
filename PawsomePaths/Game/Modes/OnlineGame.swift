//
//  OnlineGame.swift
//  Hex
//
//  Created by Duong Pham on 3/14/21.
//

import SwiftUI
import Firebase
import FirebaseDatabase

class OnlineGame: GameMode {
    var databaseRef: DatabaseReference! = Database.database().reference()
    var storageRef: StorageReference! = Storage.storage().reference()
    var matchID: String
    var localPlayer: Int
    var remotePlayerName: String
    var localPlayerName: String
    @Published var localPlayerAvatar: UIImage?
    @Published var remotePlayerAvatar: UIImage?
    
    @Published var ready = false
    @AppStorage("UID") var uid = ""
    @AppStorage("firstName") var firstName = ""
    		
    var listener: UInt = 0
        
    override init() {
        matchID = ""
        localPlayer = 0
        remotePlayerName = "Unknown"
        localPlayerName = "Player " + String(Int.random(in: 1000...9999))
        super.init()
        
        if firstName != "" {
            localPlayerName = firstName
        }
        self.joinWaitQueue()
    }
    
    override var playerTurn: String {
        if (board.playerTurn == localPlayer) {
            return firstName == "" ? "Your turn" : "\(firstName)'s turn"
        }
        else {
            return "Opponent's turn"
        }
    }
    
    override var result: String {
        let winner = board.winner
        if winner == 0 {
            return "Unknown"
        }
        else if abs(winner) == localPlayer {
            if winner > 0 {
                return "You win"
            } else {
                return "Opponent left"
            }
        }
        else {
            return "You lose"
        }
    }
    
    // MARK: - Intent(s)
    override func play(cellId: Int) {
        // check if the move is valid or not
        let move = BoardPosition(id: cellId, cols: self.board.size)
        if !board.isValid(move: move) {
            return
        }
        
        // only allow to play if current turn is for the local player
        self.databaseRef.child("matches/\(matchID)").getData { (error, snapshot) in
            if let error = error {
                print("Error getting data \(error)")
            }
            else if snapshot.exists() {
                let matchInfo = snapshot.value as! [String: Any]
                
                if matchInfo["player_turn"] as! Int == self.localPlayer {
                    self.databaseRef.child("matches/\(self.matchID)").runTransactionBlock { (data) -> TransactionResult in
                        var match = data.value as! [String: Any]
                        match["latest_move"] = cellId
                        match["player_turn"] = 3 - self.localPlayer
                        data.value = match
                        return TransactionResult.success(withValue: data)
                    }
                }
            }
            else {
                print("No data available")
            }
        }
    }
    
    override func newGame(size: Int) {
        ready = false
        self.board = GameBoard(size: size)
        exitMatch()
        joinWaitQueue()
    }
    
    // MARK: - Helper functions
    private func joinWaitQueue() {
        if uid == "" {
            // user doesnt have uid
            return
        }
        databaseRef.child("wait_queue/\(uid)").setValue(["match": "", "name": localPlayerName])
        databaseRef.child("wait_queue/\(uid)/match").observe(.value) { (snapshot) in
            if self.matchID != "" {
                return
            }
            
            if snapshot.exists() {
                self.matchID = snapshot.value as! String
                if self.matchID != "" {
                    self.joinMatch()
                }
            }
        }
    }
    
    private func setupMatch() {
        self.databaseRef.child("matches/\(self.matchID)/info").observe(.value, with: { snapshot in
            
            if !snapshot.exists() {
                // no data available
                return
            }
            
            // setting up match
            let info = snapshot.value as! [String: Any]
            let playerIds = info["player_ids"] as! [Any]
            let playerNames = info["player_names"] as! [String]
            
            if playerIds[0] as! String == self.uid {
                self.localPlayer = 1
                self.localPlayerName = playerNames[0]
                self.remotePlayerName = playerNames[1]
                
                // Get profile picture
                self.storageRef.child("users/\(playerIds[1])/avatar.png").getData(maxSize: 1024 * 1024) { data, error in
                    if error != nil {
                        print("Fail to download player's profile picture")
                    } else {
                        self.remotePlayerAvatar = UIImage(data: data!)
                        self.objectWillChange.send()
                    }
                }
                self.storageRef.child("users/\(playerIds[0])/avatar.png").getData(maxSize: 1024 * 1024) { data, error in
                    if error != nil {
                        print("Fail to download player's profile picture")
                    } else {
                        self.localPlayerAvatar = UIImage(data: data!)
                        self.objectWillChange.send()
                    }
                }
            }
            else {
                self.localPlayer = 2
                self.localPlayerName = playerNames[1]
                self.remotePlayerName = playerNames[0]
                // Get profile picture
                self.storageRef.child("users/\(playerIds[0])/avatar.png").getData(maxSize: 1024 * 1024) { data, error in
                    if error != nil {
                        print("Fail to download player's profile picture")
                    } else {
                        self.remotePlayerAvatar = UIImage(data: data!)
                        self.objectWillChange.send()
                    }
                }
                self.storageRef.child("users/\(playerIds[1])/avatar.png").getData(maxSize: 1024 * 1024) { data, error in
                    if error != nil {
                        print("Fail to download player's profile picture")
                    } else {
                        self.localPlayerAvatar = UIImage(data: data!)
                        self.objectWillChange.send()
                    }
                }
            }
            self.ready = true
            self.objectWillChange.send()
            self.listener = self.databaseRef.child("matches/\(self.matchID)").observe(.value, with: { snapshot in
                if !snapshot.exists() {
                    return;
                }
                let match = snapshot.value! as! [String: Any]
                
                // if other player left the match
                if match["done"] as! Int != 0 {
                    self.board.setWinner(playerID: self.localPlayer)
                    return
                }
                
                let id = match["latest_move"] as! Int
                if id >= 0 {
                    let move = BoardPosition(id: id, cols: self.board.size)
                    self.board.play(move: move)
                    
                    if self.board.winner != 0 {
                        // notify that the game is over
                        
                    }
                }
            })
        })
    }
    
    private func joinMatch() {
        setupMatch()
        databaseRef.child("wait_queue/\(uid)").removeValue()
    }
    
    func exitMatch() {
        databaseRef.child("wait_queue/\(uid)").removeValue()
        databaseRef.removeObserver(withHandle: listener)
        
        if matchID == "" {
            return
        }
        let matchRef = databaseRef.child("matches/\(matchID)")
        matchID = ""
        
        matchRef.runTransactionBlock { (data) -> TransactionResult in
            if var match = data.value as? [String: Any] {
                if var done = match["done"] as? Int {
                    done += 1
                    match["done"] = done
                    if done == 2 {
                        data.value = nil
                        return TransactionResult.success(withValue: data)
                    }
                    data.value = match
                }
            }
            return TransactionResult.success(withValue: data)
        }
    }
}

struct OnlineMatch: Codable {
    
}
