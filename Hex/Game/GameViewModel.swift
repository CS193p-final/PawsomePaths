//
//  GameViewModel.swift
//  Hex
//
//  Created by Duong Pham on 2/15/21.
//

import SwiftUI

class GameViewModel: ObservableObject {
    @Published var board = GameBoard()
    
    // MARK: - Access
    var cellValues: [Cell] {
        var cells = [Cell]()
        var id = 0
        for r in 0..<board.size {
            for c in 0..<board.size {
                cells.append(Cell(id: id, colorCode: board.board[r][c]))
                id += 1
            }
        }
        return cells
    }
    
    var playerTurn: String { "Player \(board.playerTurn)" }
    
    // MARK: - Intent(s)
    func play(cellId: Int) {
        _ = board.play(move: BoardPosition(id: cellId))
    }
}
