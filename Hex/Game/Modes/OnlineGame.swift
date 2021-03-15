//
//  OnlineGame.swift
//  Hex
//
//  Created by Duong Pham on 3/14/21.
//

import Foundation
import Firebase
import FirebaseDatabase

class OnlineGame: GameMode {
    var databaseRef: DatabaseReference! = Database.database().reference()
    var matchID: String
    var localPlayer: Int
    var ready = false
    
    var listener: UInt = 0
        
    override init() {
        matchID = UUID().uuidString
        localPlayer = Int.random(in: 1...2)
        super.init()
        
        
        self.findMatch()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            if !self.ready {
                print("creating a match...")
                self.createMatch()
                self.databaseRef.child("matches").child(self.matchID).observe(DataEventType.value) { (snapshot) in
                    let matchInfo = snapshot.value as! [String: Any]
                    if matchInfo["player_count"] as! Int == 2 {
                        self.ready = true
                        self.setupMatch()
                        print("ready to play")
                        print(snapshot.value!)
                    }
                }
            }
        }
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
        databaseRef.child("matches/\(matchID)/latest_move").setValue(cellId)
    }
    
    // MARK: - Helper functions
    private func setupMatch() {
        listener = databaseRef.child("matches").child(matchID).observe(.value, with: { snapshot in
            print("someone update the game: \(snapshot.value!)")
            let info = snapshot.value! as! [String: Any]
            let id = info["latest_move"] as! Int
            if id >= 0 {
                let move = BoardPosition(id: id, cols: self.board.size)
                self.board.play(move: move)
            }
        })
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
            "player_turn": 1
        ])
    }
    
    private func findMatch() {
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
                        self.ready = true
                        self.joinMatch()
                        self.setupMatch()
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
        localPlayer = 2
        databaseRef.child("matches").child(matchID).child("player_count").setValue(2)
    }
    
    
}

struct OnlineMatch: Codable {
    
}
