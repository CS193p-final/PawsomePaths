//
//  MonteCarlo.swift
//  Hex
//
//  Created by Duong Pham on 2/15/21.
//

import Foundation

struct MonteCarlo {
    var board: GameBoard
    var wins = Dictionary<GameBoard, Int>()
    var plays = Dictionary<GameBoard, Int>()
    var caculationTime = DispatchTimeInterval.seconds(2)
    var cConstant = 1.4
    
    // Causes the AI to calculate the best move from the current game state and return it
    mutating func getPlay() -> BoardPosition {
        assert(!board.legalMoves.isEmpty)
        
        //print(board.description)
        
        if board.legalMoves.count == 0 {
            return board.legalMoves.first!
        }
        
        var games = 0
        let end = DispatchTime.now().advanced(by: caculationTime)
        while DispatchTime.now() < end {
            runSimulation()
            games += 1
        }
        let moves = board.legalMoves
        let nextStates = moves.map{board.nextState(move: $0)}
        var bestWinrate: Double = 0
        var bestMove: BoardPosition = moves.first!
        
        for i in 0..<moves.count {
            let move = moves[i]
            let nextState = nextStates[i]
            if let wins = wins[nextState] {
                let winrate: Double = Double(wins) / Double(plays[nextState]!)
                if winrate > bestWinrate {
                    bestWinrate = winrate
                    bestMove = move
                }
            }
        }
        return bestMove
    }
    
    // Plays out a "random" game from current position, then updates the statistics tables with the result.s
    mutating func runSimulation() {
//        return
        var visitedStates = Set<GameBoard>()
        var state = board
        var expand = true
        
        while state.checkResult() == .unknown {
            let legalMoves = state.legalMoves
            let nextStates = legalMoves.map{state.nextState(move: $0)}
            
            // check if we have stats for all possible moves
            var allMovesHaveStats = true
            var logTotal: Double = 0
            
            for move in legalMoves {
                let nextState = state.nextState(move: move)
                if !plays.keys.contains(nextState) {
                    state = nextState
                    allMovesHaveStats = false
                    break
                }
                else {
                    logTotal += Double(plays[nextState]!)
                }
            }
            
            if allMovesHaveStats {
                logTotal = log(logTotal)
                var bestValue: Double = 0

                for i in 0..<legalMoves.count {
                    let nextState = nextStates[i]

                    let currentValue: Double = Double(wins[nextState]!) / Double(plays[nextState]!) + cConstant * sqrt(logTotal / Double(plays[nextState]!))
                    if currentValue > bestValue {
                        bestValue = currentValue
                        state = nextState
                    }
                }
            }
            else {
                state = nextStates.randomElement()!
            }
            
            if expand && !plays.keys.contains(state) {
                expand = false
                plays[state] = 0
                wins[state] = 0
            }
            visitedStates.insert(state)
        }
        
        for s in visitedStates {
            if !plays.keys.contains(s) {
                continue
            }
            plays[s]! += 1
            // TODO: Fix this
            // Here we assume that computer will always go second
            if 2 == state.winner {
                wins[s]! += 1
            }
        }
        
    }
}
