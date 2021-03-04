//
//  Minimax.swift
//  Hex
//
//  Created by Duong Pham on 2/25/21.
//

import SwiftUI

struct Minimax {
    var board: GameBoard
    var computer: Int = 2
    var caculationTime = DispatchTimeInterval.seconds(200)
    var endTime = DispatchTime.now()
    
    mutating func getPlay() -> BoardPosition {
        endTime = DispatchTime.now().advanced(by: caculationTime)
        var bestMove: BoardPosition = BoardPosition(r: 0, c: 0, cols: board.size)
        
        // Apply iterative deeping on top minimax
        let maxDifficulty = board.difficulty
        for difficulty in 1...3 {
            board.difficulty = difficulty
            var eval = 0
            let score = minimax(depth: difficulty, isMaximizingPlayer: true, a: Int.min, b: Int.max, bestMove: &bestMove, critical: &eval)
            if eval == Int.min || eval == Int.max {
                break
            }

            print("difficulty = \(difficulty), score = \(score) eval = \(eval)")
        }
        print(bestMove)
        print()
        return bestMove
    }
    
    mutating func minimax(depth: Int, isMaximizingPlayer: Bool, a: Int, b: Int, bestMove: inout BoardPosition, critical: inout Int) -> Int {

        if depth == 0 { // TODO: add time constant
            return staticEvaluate(player: computer)
        }
        
        var eval: Int
        var a = a
        var b = b
        
        if isMaximizingPlayer { // Maximize player's turn
            var maxEval = Int.min
            
            // Regard every possible move the maximizing player can play as a next game state
            let goodMoves = board.goodMoves
            for move in goodMoves {
                if DispatchTime.now() > endTime {
                    break
                }
                board.play(move: move)
                
                eval = minimax(depth: depth-1, isMaximizingPlayer: false, a: a, b: b, bestMove: &bestMove, critical: &critical)
                
                // If the opponent has a winning move next round, then there is no need to search futher, the priority is to block it
                if critical == Int.min {
                    board.undo(move: move)
                    return critical
                }
                
                if maxEval < eval {
                    maxEval = eval

                    // Update the best move only at the top level of the game tree
                    if depth == board.difficulty {
                        print("maxEval = \(maxEval), tmp move = \(bestMove)")
                        bestMove = move
                        if maxEval == Int.max {
                            board.undo(move: move)
                            critical = Int.max // Notify that a winning move is available
                            return maxEval
                        }
                    }
                }
                
                board.undo(move: move)
                a = max(eval, a)
                if a >= b {
                    return maxEval
                }
            
            }
            
            return maxEval
        }
        else { // Minimizing player's turn
            var minEval = Int.max
            
            // Regard every possible move the minimizing player can play as a next game state
            let goodMoves = board.goodMoves
            for move in goodMoves {
                if DispatchTime.now() > endTime {
                    break
                }
                board.play(move: move)
                
                eval = minimax(depth: depth-1, isMaximizingPlayer: true, a: a, b: b, bestMove: &bestMove, critical: &critical)
                
                if minEval > eval {
                    minEval = eval
                    
                    // Update the best move if the opponent has a winning move in the next round
                    if depth == board.difficulty - 1 && minEval == Int.min {
                        bestMove = move
                        print("Opponent will win next move")
                        board.undo(move: move)
                        critical = Int.min // Notify that the opponent has a winning move
                        return minEval
                        
                    }
                }
                
                board.undo(move: move)
                b = min(eval, b)
                if a >= b {
                    return minEval
                }
            }
            return minEval
        }
    }
    
    func staticEvaluate(player: Int) -> Int {
        let winner = board.winner
        if winner == 0 {
            return hexesNeededToWinDifference(player: player)
        }
        
        if winner == player {
            return Int.max
        }
        else {
            return Int.min
        }
    }
    
    private func hexesNeededToWinDifference(player: Int) -> Int {
        var hexesNeededForPlayer1 = Int.max
        var hexesNeededForPlayer2 = Int.max
        
        let size = board.size
        
        // Compute hexes needed for player 1 to win (up-to-down BFS search)
        var costMatrix = Array(repeating: Array(repeating: Int.max, count: size), count: size)
        initCostMatrix(&costMatrix, player: 1)
//        print(costMatrix)
        for r in 0..<size {
            for c in 0..<size {
                if board[r, c] == 2 { // from this cell, the cost to other cells is infinity (for player 1), therefore we skip it
                    continue
                }
                
                var transCost: Int
                // Right neighbor
                transCost = transitionCost(to: BoardPosition(r: r, c: c+1, cols: size), player: 1)
                if transCost != -1 {
                    costMatrix[r][c+1] = min(costMatrix[r][c+1], Int.add(costMatrix[r][c], transCost))
                }
                
                // Left neighbor
                transCost = transitionCost(to: BoardPosition(r: r, c: c-1, cols: size), player: 1)
                if transCost != -1 {
                    costMatrix[r][c-1] = min(costMatrix[r][c-1], Int.add(costMatrix[r][c], transCost))
                }
                
                // Down-left neighbor
                transCost = transitionCost(to: BoardPosition(r: r+1, c: c-1, cols: size), player: 1)
                if transCost != -1 {
                    costMatrix[r+1][c-1] = min(costMatrix[r+1][c-1], Int.add(costMatrix[r][c], transCost))
                }
                
                // Down neighbor
                transCost = transitionCost(to: BoardPosition(r: r+1, c: c, cols: size), player: 1)
                if transCost != -1 {
                    costMatrix[r+1][c] = min(costMatrix[r+1][c], Int.add(costMatrix[r][c], transCost))
                }
            }
        }
        
        for c in 0..<size {
            hexesNeededForPlayer1 = min(hexesNeededForPlayer1, costMatrix[size-1][c])
        }
        
        // Compute hexes need for player 2 to win (left-to-right BFS search)
        costMatrix = Array(repeating: Array(repeating: Int.max, count: size), count: size)
        initCostMatrix(&costMatrix, player: 2)
        
        for c in 0..<size {
            for r in 0..<size {
                if board[r, c] == 1 { // from this cell, the cost to other cells is infinity (for player 2), therefore we skip it
                    continue
                }
                
                var transCost: Int
                // Up neighbor
                transCost = transitionCost(to: BoardPosition(r: r-1, c: c, cols: size), player: 2)
                if transCost != -1 {
                    costMatrix[r-1][c] = min(costMatrix[r-1][c], Int.add(costMatrix[r][c], transCost))
                }
                
                // Down neighbor
                transCost = transitionCost(to: BoardPosition(r: r+1, c: c, cols: size), player: 2)
                if transCost != -1 {
                    costMatrix[r+1][c] = min(costMatrix[r+1][c], Int.add(costMatrix[r][c], transCost))
                }
                
                // Right neighbor
                transCost = transitionCost(to: BoardPosition(r: r, c: c+1, cols: size), player: 2)
                if transCost != -1 {
                    costMatrix[r][c+1] = min(costMatrix[r][c+1], Int.add(costMatrix[r][c], transCost))
                }
                
                // Up-right neighbor
                transCost = transitionCost(to: BoardPosition(r: r-1, c: c+1, cols: size), player: 2)
                if transCost != -1 {
                    costMatrix[r-1][c+1] = min(costMatrix[r-1][c+1], Int.add(costMatrix[r][c], transCost))
                }
            }
        }
        
        for r in 0..<size {
            hexesNeededForPlayer2 = min(hexesNeededForPlayer2, costMatrix[r][size-1])
        }
        
        return (hexesNeededForPlayer2 - hexesNeededForPlayer1) * (player == 1 ? 1 : -1)
    }
    
    // MARK: - Utilities
    private func transitionCost(to position: BoardPosition, player: Int) -> Int {
        if !board.isInside(position: position) {
            return -1
        }
        if board.board[position.r][position.c] == 0 {
            return 1
        }
        return board.board[position.r][position.c] == player ? 0 : Int.max
    }
    
    private func initCostMatrix(_ matrix: inout Array<Array<Int>>, player: Int) {
        let size = matrix.count
        for k in 0..<size {
            if player == 1 {
                matrix[0][k] = transitionCost(to: BoardPosition(r: 0, c: k, cols: size), player: player)
            }
            else {
                matrix[k][0] = transitionCost(to: BoardPosition(r: k, c: 0, cols: size), player: player)
            }
        }
    }
}
