//
//  MainView.swift
//  Hex
//
//  Created by Duong Pham on 3/19/21.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject var viewRouter: ViewRouter
    @EnvironmentObject var audioManager: AudioManager
    @EnvironmentObject var modalManager: ModalManager

    var body: some View {
        switch viewRouter.currentScreen {
        case .welcome:
            WelcomeView()
                .environmentObject(viewRouter)
                .environmentObject(audioManager)
                .environmentObject(modalManager)
        case .singlePlayerGame(let continueGame):
            GameView(hexGame: SinglePlayerGame(name: "singlePlayer"), continueGame: continueGame)
                .environmentObject(viewRouter)
                .environmentObject(audioManager)
                .environmentObject(modalManager)
        case .twoPlayersGame(let continueGame):
            GameView(hexGame: TwoPlayersGame(name: "twoPlayer"), continueGame: continueGame)
                .environmentObject(viewRouter)
                .environmentObject(audioManager)
                .environmentObject(modalManager)
        case .onlineGame:
            let onlineGame: OnlineGame? = OnlineGame()
            OnlineGameView(hexGame: onlineGame!)
                .environmentObject(viewRouter)
                .environmentObject(audioManager)
                .environmentObject(modalManager)
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
