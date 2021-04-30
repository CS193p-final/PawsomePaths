//
//  ViewRouter.swift
//  Hex
//
//  Created by Duong Pham on 3/19/21.
//

import SwiftUI

enum Screen {
    case welcome
    case singlePlayerGame(Bool)
    case twoPlayersGame(Bool)
    case onlineGame
    case howToPlay
    case friendList
}

class ViewRouter: ObservableObject {
    @Published var currentScreen: Screen = .welcome
}
