//
//  SinglePlayerGame.swift
//  Hex
//
//  Created by Duong Pham on 2/17/21.
//

import Foundation

class SinglePlayerGame: GameMode {
    
    override var playerTurn: String {
        if (board.playerTurn == 1) {
            return "Your turn"
        }
        else {
            return "Computer's turn"
        }
    }
    
    override var result: String {
        switch board.checkResult() {
        case .player1Win: return "You wins"
        case .player2Win: return "Computer wins"
        case .unknown: return "Unknown"
        }
    }
    
    // MARK: - Intent(s)
    override func play(cellId: Int) {
        _ = board.play(move: BoardPosition(id: cellId))
        if gameEnded {
            return
        }
        let move = DumpAI(currentState: board).makeMove()
        _ = board.play(move: move)
    }
}

