//
//  GameBoard.swift
//  Hex
//
//  Created by Duong Pham on 2/15/21.
//

import Foundation
import Combine

enum GameResult {
    case unknown
    case player1Win
    case player2Win
}

struct BoardPosition {
    var r: Int
    var c: Int
    
    init(r: Int, c: Int) {
        self.r = r
        self.c = c
    }
    
    init(id: Int) {
        // TODO: Fix magic number
        r = id / 11
        c = id % 11
    }
}

struct GameBoard: Hashable, Codable {
    private static let dr = [-1, -1, 0, 1, 1, 0]
    private static let dc = [0, 1, 1, 0, -1, -1]
    
    private(set) var size: Int
    private(set) var board: [[Int]]
    private(set) var playerTurn: Int = 1
    
    var json: Data? {
        try? JSONEncoder().encode(self)
    }
    
    init?(json: Data?) {
        if json != nil, let newBoard = try? JSONDecoder().decode(GameBoard.self, from: json!) {
            self = newBoard
        } else {
            return nil
        }
    }
    
    init(size: Int = 11) {
        self.size = size
        board = Array(repeating: Array(repeating: 0, count: size), count: size)
    }
    
    var legalMoves: [BoardPosition] {
        var moves = [BoardPosition]()
        for r in 0..<size {
            for c in 0..<size {
                if board[r][c] == 0 {
                    moves.append(BoardPosition(r: r, c: c))
                }
            }
        }
        return moves
    }
    
    mutating func play(move: BoardPosition) -> GameBoard {
        board[move.r][move.c] = playerTurn
        playerTurn = 3 - playerTurn
        return self
    }
    
    func checkResult() -> GameResult {
        
        // Check if player 1 has connected top to bottom
        var visited = Array(repeating: Array(repeating: false, count: size), count: size)
        var queue = Queue<BoardPosition>()
        
        for c in 0..<size {
            if board[0][c] == 1 {
                queue.enqueue(BoardPosition(r: 0, c: c))
                visited[0][c] = true
            }
        }
        
        while !queue.isEmpty {
            if let front = queue.dequeue() {
                let r = front.r
                let c = front.c
                if r == size-1 {
                    return .player1Win
                }
                
                for i in 0..<GameBoard.dr.count {
                    let r_ = r + GameBoard.dr[i]
                    let c_ = c + GameBoard.dc[i]
                    if (isInside(r: r_, c: c_) && board[r_][c_] == 1 && !visited[r_][c_]) {
                        visited[r_][c_] = true
                        queue.enqueue(BoardPosition(r: r_, c: c_))
                    }
                }
            }
        }
        
        // Check if player 2 has connected left to right
        visited = Array(repeating: Array(repeating: false, count: size), count: size)
        queue = Queue<BoardPosition>()
        
        for r in 0..<size {
            if board[r][0] == 2 {
                queue.enqueue(BoardPosition(r: r, c: 0))
                visited[r][0] = true
            }
        }
        
        while !queue.isEmpty {
            if let front = queue.dequeue() {
                let r = front.r
                let c = front.c
                if c == size-1 {
                    return .player2Win
                }
                
                for i in 0..<GameBoard.dr.count {
                    let r_ = r + GameBoard.dr[i]
                    let c_ = c + GameBoard.dc[i]
                    if (isInside(r: r_, c: c_) && board[r_][c_] == 2 && !visited[r_][c_]) {
                        visited[r_][c_] = true
                        queue.enqueue(BoardPosition(r: r_, c: c_))
                    }
                }
            }
        }
        
        return .unknown
    }
    
    private func isInside(position: BoardPosition) -> Bool {
        isInside(r: position.r, c: position.c)
    }
    
    private func isInside(r: Int, c: Int) -> Bool {
        (r >= 0 && c >= 0 && r < size && c < size)
    }
}
