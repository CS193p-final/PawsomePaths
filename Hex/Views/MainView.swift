//
//  MainView.swift
//  Hex
//
//  Created by Duong Pham on 3/19/21.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject var viewRouter: ViewRouter
    var body: some View {
        switch viewRouter.currentScreen {
        case .welcome:
            WelcomeView()
        case .singlePlayerGame(let continueGame):
            GameView(hexGame: SinglePlayerGame(name: "singlePlayer"), continueGame: continueGame)
        case .twoPlayersGame(let continueGame):
            GameView(hexGame: TwoPlayersGame(name: "twoPlayer"), continueGame: continueGame)
        case .onlineGame:
            let onlineGame: OnlineGame? = OnlineGame()
            OnlineGameView(hexGame: onlineGame!)
        case .howToPlay:
            HowToPlayView(soundOn: true)
        case .friendList:
            FriendList()
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
