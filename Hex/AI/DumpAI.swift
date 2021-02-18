//
//  DumpAI.swift
//  Hex
//
//  Created by Duong Pham on 2/17/21.
//

import Foundation

struct DumpAI {
    let currentState: GameBoard
    
    func makeMove() -> BoardPosition {
        assert(currentState.legalMoves.count > 0)
        return currentState.legalMoves.randomElement()!
    }
}
