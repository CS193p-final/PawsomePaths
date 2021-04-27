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
    var databaseRef: DatabaseReference! = Database.database(url:"http://localhost:9000/?ns=hex-game-80370-default-rtdb").reference()
    var matchID: String
    var localPlayer: Int
    var remotePlayerName: String
    var localPlayerName: String
    
    @Published var ready = false
    @AppStorage("UID") var uid = ""
    @AppStorage("firstName") var firstName = ""
    		
    var listener: UInt = 0
        
    override init() {
        matchID = ""
        localPlayer = 0
        remotePlayerName = "Unknown"
        localPlayerName = "Guest" + String(Int.random(in: 1000...9999))
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
        else if winner == localPlayer {
            return "You win"
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
                // if the match is done
//                if matchInfo["is_done"] as! Int == 1 {
//
//                }
                
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
            print("user doesn't have an UID")
            return
        }
        databaseRef.child("wait_queue/\(uid)").setValue(["match": "", "name": localPlayerName])
        databaseRef.child("wait_queue/\(uid)/match").observe(.value) { (snapshot) in
            if self.matchID != "" {
                return
            }
            
            if snapshot.exists() {
                print(snapshot.value)
                self.matchID = snapshot.value as! String
                if self.matchID != "" {
                    self.joinMatch()
                }
            }
        }
    }
    
    private func setupMatch() {
        self.databaseRef.child("matches/\(self.matchID)/info/player_ids").getData { (error, snapshot) in
            if let error = error {
                print("Error getting data \(error)")
            }
            else if snapshot.exists() {
                let playerIds = snapshot.value as! [Any]
                print("snapshot = \(snapshot.value)")
                if playerIds[0] as! String == self.uid {
                    self.localPlayer = 1
                }
                else {
                    self.localPlayer = 2
                }
                self.ready = true
                print("I'm ready")
                self.objectWillChange.send()
                self.listener = self.databaseRef.child("matches/\(self.matchID)").observe(.value, with: { snapshot in
                    if !snapshot.exists() {
                        return;
                    }
                    let match = snapshot.value! as! [String: Any]
                    print(snapshot)
                    let id = match["latest_move"] as! Int
                    if id >= 0 {
                        let move = BoardPosition(id: id, cols: self.board.size)
                        self.board.play(move: move)
                        
                        if self.board.winner != 0 {
                            // notify that the game is over
                            
                        }
                    }
                })
            }
            else {
                print("No data available")
            }
        }
        
    }
    
    private func startMatch() {
        
    }
    
    private func findMatch() {
        // Ignore this warning since firebase event callbacks are always on main thread.
        /// Publishing changes from background threads is not allowed; make sure to publish values from the main thread (via operators like receive(on:)) on model updates.
        self.databaseRef.child("matches").getData { (error, snapshot) in
            if let error = error {
                print("Error getting data \(error)")
            }
            else if snapshot.exists() {
                let matches = snapshot.value as! [String: [String: Any]]
                
                for match in matches {
                    let id = match.key
                    let matchInfo = match.value
                    if matchInfo["player_count"] as! Int == 1 {
                        print("found a match: \(match)")
                        self.matchID = id
                        self.joinMatch()
                        self.setupMatch()
                        self.ready = true
                        self.objectWillChange.send()
                        return
                    }
                }
            }
            else {
                print("No data available")
            }
        }
    }
    
    private func joinMatch() {
        setupMatch()
        databaseRef.child("wait_queue/\(uid)").removeValue()
    }
    
    func exitMatch() {
        matchID = ""
        print("Exiting match ... ")
        print("uid = \(uid)")
        databaseRef.child("wait_queue/\(uid)").removeValue()
        databaseRef.removeObserver(withHandle: listener)
        databaseRef.child("matches/\(matchID)").removeValue()
    }
}

struct OnlineMatch: Codable {
    
}
