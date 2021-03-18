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

struct BoardPosition: Hashable {
    var r: Int
    var c: Int
    var cols: Int
    
    init(r: Int, c: Int, cols: Int) {
        self.r = r
        self.c = c
        self.cols = cols
    }
    
    init(id: Int, cols: Int) {
        // TODO: Fix magic number
        r = id / cols
        c = id % cols
        self.cols = cols
    }
}

struct GameBoard: Hashable, Codable {
    private static let dr = [-1, -1, 0, 1, 1, 0]
    private static let dc = [0, 1, 1, 0, -1, -1]
    
    private(set) var size: Int
    var board: [[Int]]
    var difficulty = 3
    private(set) var playerTurn: Int = 1
    var soundOn: Bool
    var musicOn: Bool
    
    var json: Data? {
        try? JSONEncoder().encode(self)
    }
    
    var description: String {
        var res = ""
        for r in 0..<size {
            var line = ""
            for _ in 0..<r {
                line += " "
            }
            for c in 0..<size {
                line += String(board[r][c])
                line += " "
            }
            res += line
            res += "\n"
        }
        return res
    }
    
    init?(json: Data?) {
        if json != nil, let newBoard = try? JSONDecoder().decode(GameBoard.self, from: json!) {
            self = newBoard
        } else {
            return nil
        }
    }
    
    init(size: Int = 6, musicOn: Bool, soundOn: Bool) {
        self.size = size
        board = Array(repeating: Array(repeating: 0, count: size), count: size)
        self.musicOn = musicOn
        self.soundOn = soundOn
    }
    
    subscript(row: Int, col: Int) -> Int {
        board[row][col]
    }
    
    var legalMoves: [BoardPosition] {
        var moves = [BoardPosition]()
        for r in 0..<size {
            for c in 0..<size {
                if board[r][c] == 0 {
                    moves.append(BoardPosition(r: r, c: c, cols: size))
                }
            }
        }
        return moves
    }
    
    // return possible good move (at most 2 hexes always from occupied cell)
    var goodMoves: [BoardPosition] {
        var queue = Queue<BoardPosition>()
        var distance = Array(repeating: Array(repeating: -1, count: size), count: size)
        
        for r in 0..<size {
            for c in 0..<size {
                if board[r][c] != 0 {
                    queue.enqueue(BoardPosition(r: r, c: c, cols: size))
                    distance[r][c] = 0
                }
            }
        }
        
        while !queue.isEmpty {
            let cell = queue.dequeue()!
            for i in 0..<GameBoard.dr.count {
                let r_ = cell.r + GameBoard.dr[i]
                let c_ = cell.c + GameBoard.dc[i]
                if isInside(r: r_, c: c_) && distance[r_][c_] == -1 {
                    distance[r_][c_] = distance[cell.r][cell.c] + 1
                    queue.enqueue(BoardPosition(r: r_, c: c_, cols: size))
                }
            }
        }
        
        var moves = [BoardPosition]()
        for r in 0..<size {
            for c in 0..<size {
                if distance[r][c] <= 2 && distance[r][c] != 0 {
                    moves.append(BoardPosition(r: r, c: c, cols: size))
                }
            }
        }
        return moves
    }
    
    var winner: Int {
        switch checkResult() {
        case .player1Win:
            return 1
        case .player2Win:
            return 2
        default:
            return 0
        }
    }
    
    func nextState(move: BoardPosition) -> GameBoard {
        var newState = self
        newState.play(move: move)
        return newState
    }
    
    mutating func play(move: BoardPosition) {
        if board[move.r][move.c] != 0 {
            print("Invalid move: \(move)")
            return
        }
        board[move.r][move.c] = playerTurn
        playerTurn = 3 - playerTurn
    }
    
    mutating func undo(move: BoardPosition) {
        assert(board[move.r][move.c] != playerTurn)
        board[move.r][move.c] = 0
        playerTurn = 3 - playerTurn
    }
    
    func checkResult() -> GameResult {
        // Check if player 1 has connected top to bottom
        var visited = Array(repeating: Array(repeating: false, count: size), count: size)
        var queue = Queue<BoardPosition>()
        
        for c in 0..<size {
            if board[0][c] == 1 {
                queue.enqueue(BoardPosition(r: 0, c: c, cols: size))
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
                        queue.enqueue(BoardPosition(r: r_, c: c_, cols: size))
                    }
                }
            }
        }
        
        // Check if player 2 has connected left to right
        visited = Array(repeating: Array(repeating: false, count: size), count: size)
        queue = Queue<BoardPosition>()
        
        for r in 0..<size {
            if board[r][0] == 2 {
                queue.enqueue(BoardPosition(r: r, c: 0, cols: size))
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
                        queue.enqueue(BoardPosition(r: r_, c: c_, cols: size))
                    }
                }
            }
        }
        
        return .unknown
    }
    
    func isInside(position: BoardPosition) -> Bool {
        isInside(r: position.r, c: position.c)
    }
    
    private func isInside(r: Int, c: Int) -> Bool {
        (r >= 0 && c >= 0 && r < size && c < size)
    }

    mutating func toggleSound() {
        soundOn = !soundOn
    }

    mutating func toggleMusic() {
        musicOn = !musicOn
    }
}
