//
//  GameBoard.swift
//  Hex
//
//  Created by Duong Pham on 2/15/21.
//

import Foundation

enum GameResult {
    case unknown
    case player1Win
    case player2Win
}

struct BoardPosition {
    var r: Int
    var c: Int
}

struct GameBoard {
    private static let dr = [-1, -1, 0, 1, 1, 0]
    private static let dc = [0, 1, 1, 0, -1, -1]
    
    var size: Int
    var board: [[Int]]
    var playerTurn: Int {
        // TODO: optimize this computed variable
        var player1 = 0
        for r in 0..<size {
            for c in 0..<size {
                if board[r][c] == 1 {
                    player1 -= 1
                }
                if board[r][c] == 2 {
                    player1 += 1
                }
            }
        }
        assert(player1 > -2 && player1 < 2)
        if player1 < 0 {
            return 2
        }
        else {
            return 1
        }
    }
    
    
    init(size: Int = 11) {
        self.size = size
        board = Array(repeating: Array(repeating: 0, count: size), count: size)
    }
    
    private func checkResult() -> GameResult {
        
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
