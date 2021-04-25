//
//  GameMode.swift
//  Hex
//
//  Created by Duong Pham on 2/18/21.
//

import Foundation
import Combine
import UIKit

class GameMode: ObservableObject {
    @Published var board: GameBoard
    var isIpad = UIDevice.current.userInterfaceIdiom == .pad
    private var autoSaveCancellable: AnyCancellable?
    var maxSize: Int {
        isIpad ? 13 : 11
    }
    private (set) var minSize: Int = 3
    
    init() {
        self.board = GameBoard(size: 11)
    }
    
    init(name: String) {
        let defaultsKey = "GameMode.\(name)"
        board = GameBoard(json: UserDefaults.standard.data(forKey: defaultsKey)) ?? GameBoard(size: 11)
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
    
    var playerTurn: String {
        "\(board.playerTurn == 1 ? "Red player" : "Blue player")'s turn"
    }
    
    var result: String {
        switch board.checkResult() {
        case .player1Win: return "Red player wins"
        case .player2Win: return "Blue player wins"
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
    
//    var soundOn: Bool {
//        board.soundOn
//    }
//
//    var musicOn: Bool {
//        board.musicOn
//    }
    
    // MARK: - Intent(s)
    func play(cellId: Int) {
        board.play(move: BoardPosition(id: cellId, cols: board.size))
        //playSound("error", type: "wav",  )
    }
    
    func newGame(size: Int) {
        self.board = GameBoard(size: size)
    }
    
    func incrementSize() {
        if board.size < maxSize {
            let size = board.size + 1
            newGame(size: size)
        }
    }
    
    func decrementSize() {
        if board.size > minSize {
            let size = board.size - 1
            newGame(size: size)
        }
    }
    
//    func toggleSound() {
//        board.toggleSound()
//    }
//
//    func toggleMusic() {
//        board.toggleMusic()
//    }
}
