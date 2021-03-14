//
//  GameMode.swift
//  Hex
//
//  Created by Duong Pham on 2/18/21.
//

import Foundation
import Combine

class GameMode: ObservableObject {
    @Published var board: GameBoard

    private var autoSaveCancellable: AnyCancellable?

    
    init() {
        self.board = GameBoard(size: 7)
    }
    
    init(name: String) {
        let defaultsKey = "GameMode.\(name)"
        board = GameBoard(json: UserDefaults.standard.data(forKey: defaultsKey)) ?? GameBoard()
        autoSaveCancellable = $board.sink { board in
            UserDefaults.standard.setValue(board.json, forKey: defaultsKey)
        }
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
        case .unknown: return "You win"
        }
    }
    
    var gameEnded: Bool {
        switch board.checkResult() {
        case .player1Win: return true
        case .player2Win: return true
        case .unknown: return false
        }
    }
    
    var soundOn: Bool {
        board.soundOn
    }
    
    var musicOn: Bool {
        board.musicOn
    }
    
    // MARK: - Intent(s)
    func play(cellId: Int) {
        board.play(move: BoardPosition(id: cellId, cols: board.size))
    }
    
    func newGame(size: Int) {
        self.board = GameBoard(size: size)
    }
    
    func incrementSize() {
        if board.size < 11 {
            let size = board.size + 1
            newGame(size: size)
        }
    }
    
    func decrementSize() {
        if board.size > 3 {
            let size = board.size - 1
            newGame(size: size)
        }
    }
    
    func toggleSound() {
        board.toggleSound()
    }
    
    func toggleMusic() {
        board.toggleMusic()
    }
}
