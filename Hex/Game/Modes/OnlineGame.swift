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
    var matchID: String
    var localPlayer: Int
    
    @Published var ready = false
    @AppStorage("UID") var uid = ""
    		
    var listener: UInt = 0
        
    override init() {
        matchID = ""
        localPlayer = Int.random(in: 1...2)
        super.init()
        
        self.joinWaitQueue()
        
//        self.findMatch()
//
//        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//            if !self.ready {
//                self.createMatch()
//                guard self.matchID != "" else {
//                    print("Cannot create a match")
//                    return
//                }
//                self.databaseRef.child("matches").child(self.matchID).observe(DataEventType.value) { (snapshot) in
//                    if !snapshot.exists() {
//                        return
//                    }
//                    let matchInfo = snapshot.value as! [String: Any]
//                    if matchInfo["player_count"] as! Int == 2 {
//                        self.setupMatch()
//                        self.ready = true
//                        self.objectWillChange.send()
//                    }
//                }
//            }
//        }
    }
    
    override var playerTurn: String {
        if (board.playerTurn == localPlayer) {
            return "Your turn"
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
        self.board = GameBoard(size: size, musicOn: board.musicOn, soundOn: board.soundOn)
        exitMatch()
        joinWaitQueue()
    }
    
    // MARK: - Helper functions
    private func joinWaitQueue() {
        if uid == "" {
            print("user doesn't have an UID")
            return
        }
        databaseRef.child("wait_queue/\(uid)").setValue("")
        databaseRef.child("wait_queue/\(uid)").observe(.value) { (snapshot) in
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
        databaseRef.child("matches/\(matchID)/ready/\(uid)").setValue(true)
        databaseRef.child("matches/\(matchID)/ready").observe(.childAdded) { (snapshot) in
            if snapshot.key != self.uid {
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
                    }
                    else {
                        print("No data available")
                    }
                }

                
            }
        }
    }
    
    private func startMatch() {
        
    }
    
    private func createMatch() {
        // assume that player 1 always create the match
        localPlayer = 1
        let ref = databaseRef.child("matches").childByAutoId()
        matchID = ref.key!
        ref.setValue([
            "player_count": 1,
            "board_size": board.size,
            "latest_move": -1,
            "player_turn": 1,
            "timeout": 0,
            "is_done": true
        ])
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
        databaseRef.child("wait_queue/\(uid)").removeValue()
        setupMatch()
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
