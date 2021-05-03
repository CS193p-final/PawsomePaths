//
//  NewGameButton.swift
//  PawsomePaths
//
//  Created by Duong Pham on 5/2/21.
//

import SwiftUI

struct NewGameButton: View {
    @EnvironmentObject var viewRouter: ViewRouter

    var localGame: GameMode? = nil
    var onlineGame: OnlineGame? = nil
    let buttonFontSize: CGFloat
    var showResult: Bool
    
    var body: some View {
        Button(action: {
            if let game = onlineGame {
                game.exitMatch()
                viewRouter.currentScreen = .onlineGame
            } else if let game = localGame {
                showResult ? game.newGame(size: game.board.size) : nil
            } else {
                print("hex game is empty")
            }
        }) {
            RoundedRectangle(cornerRadius: buttonFontSize)
                .frame(width: buttonFontSize * 10, height: buttonFontSize * 3, alignment: .center)
                .overlay(Text("Reset Game").foregroundColor(.white)
                            .font(Font.custom("KronaOne-Regular", size: buttonFontSize)))
                .foregroundColor(Color.hunterGreen)
        }
    }
}
