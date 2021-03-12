//
//  TwoPlayersGame.swift
//  Hex
//
//  Created by Duong Pham on 2/15/21.
//

import SwiftUI
import Combine

class TwoPlayersGame: GameMode {
    private var autoSaveCancellable: AnyCancellable?
    
//    init(name: String) {
//        super.init()
//        let defaultsKey = "HexGame.\(name)"
//        board = GameBoard(json: UserDefaults.standard.data(forKey: defaultsKey)) ?? GameBoard()
//        autoSaveCancellable = $board.sink { board in
//            UserDefaults.standard.setValue(board.json, forKey: defaultsKey)
//        }
//    }
}
