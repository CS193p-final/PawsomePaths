//
//  GameMode.swift
//  Hex
//
//  Created by Duong Pham on 2/18/21.
//

import Foundation

class GameMode: ObservableObject {
    @Published var board: GameBoard
    
    init() {
        self.board = GameBoard(size: 9)
    }
    
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
    
    var gameEnded: Bool {
        switch board.checkResult() {
        case .player1Win: return true
        case .player2Win: return true
        case .unknown: return false
        }
    }
    
    // MARK: - Intent(s)
    func play(cellId: Int) {
        board.play(move: BoardPosition(id: cellId, cols: board.size))
    }
    
    func newGame() {
        self.board = GameBoard(size: 11)
    }
}
