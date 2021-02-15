//
//  GameState.swift
//  Hex
//
//  Created by Duong Pham on 2/15/21.
//

import SwiftUI

class GameState: ObservableObject {
    @Published var board = GameBoard()
    
    // MARK: - Access
    var cellValues: [Int] {
        var array = [Int]()
        for r in 0..<board.size {
            for c in 0..<board.size {
                array.append(board.board[r][c])
            }
        }
        return array
    }
    
    var playerTurn: String { "Player \(board.playerTurn)" }
    
    // MARK: - Intent(s)
    
}
