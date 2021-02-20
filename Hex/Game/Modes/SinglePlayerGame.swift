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
        board.play(move: BoardPosition(id: cellId, cols: board.size))
        objectWillChange.send()
        if gameEnded {
            return
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            let boardCopy = self.board
            var mcts = MonteCarlo(board: boardCopy)
            self.board.play(move: mcts.getPlay())
        }
    }
}

