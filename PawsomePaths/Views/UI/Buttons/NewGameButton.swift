//
//  NewGameButton.swift
//  PawsomePaths
//
//  Created by Duong Pham on 5/2/21.
//

import SwiftUI

struct NewGameButton: View {
    @EnvironmentObject var viewRouter: ViewRouter

    var isOnlineGame: Bool
    var game: GameMode
    let buttonFontSize: CGFloat
    var showResult: Bool
    private let hunterGreen = Color(red: 0.15625, green: 0.3125, blue: 0.1796875, opacity: 0.5)
    
    var body: some View {
        Button(action: {
            if isOnlineGame {
                viewRouter.currentScreen = .onlineGame
            } else {
                showResult ? game.newGame(size: game.board.size) : nil
            }
        }
    ) {
            RoundedRectangle(cornerRadius: buttonFontSize)
                .frame(width: buttonFontSize * 10, height: buttonFontSize * 3, alignment: .center)
                .overlay(Text("Reset Game").foregroundColor(.white)
                            .font(Font.custom("KronaOne-Regular", size: buttonFontSize)))
                .foregroundColor(hunterGreen)
        }
    }
}
