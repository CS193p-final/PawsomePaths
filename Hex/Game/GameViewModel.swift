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
    
    var result: String {
        switch board.checkResult() {
        case .player1Win: return "Player 1 wins"
        case .player2Win: return "Player 2 wins"
        case .unknown: return "Unknown"
        }
    }
    
    init(board: GameBoard) {
        self.board = board
    }
    
    init() {
        self.board = GameBoard(size: 11)
    }
    
    // MARK: - Intent(s)
    func play(cellId: Int) {
        _ = board.play(move: BoardPosition(id: cellId))
    }
    
    func newGame() {
        self.board = GameBoard(size: 11)
    }
}
