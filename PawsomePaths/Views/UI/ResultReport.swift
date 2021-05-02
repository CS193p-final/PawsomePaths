//
//  ResultReport.swift
//  PawsomePaths
//
//  Created by Duong Pham on 5/2/21.
//

import SwiftUI

struct ResultReport: View {
    @EnvironmentObject var viewRouter: ViewRouter
    @EnvironmentObject var audioManager: AudioManager
    
    var isOnlineGame: Bool
    var game: GameMode
    var showResult: Bool

    private let buttonFontSize: CGFloat = UIDevice.current.userInterfaceIdiom == .pad ? 60 : 30
    private let resultFontSize: CGFloat = UIDevice.current.userInterfaceIdiom == .pad ? 50 : 25
    private let scaleEffect: CGFloat = UIDevice.current.userInterfaceIdiom == .pad ? 2 : 1.2

    private let hunterGreen = Color(red: 0.15625, green: 0.3125, blue: 0.1796875, opacity: 0.5)
    private let imageHeight: CGFloat = 450
    private let imageWidth: CGFloat = 300


    var body: some View {
        GeometryReader { geometry in
            ZStack {
                VStack {
                    Text("\(game.result)")
                        .multilineTextAlignment(.center)
                        .font(Font.custom("PressStart2P-Regular", size: geometry.size.width / resultFontSize))
                        .foregroundColor(.black)
                        .padding(.bottom, 60)
                        .frame(width: imageWidth, alignment: .center)
                    
                    VStack {
                        NewGameButton(isOnlineGame: isOnlineGame, game: game, buttonFontSize: geometry.size.width / buttonFontSize, showResult: showResult)
                        Button {
                            viewRouter.currentScreen = .welcome
                            game.newGame(size: game.board.size)
                        } label: {
                            ZStack {
                                RoundedRectangle(cornerRadius: geometry.size.width / buttonFontSize)
                                    .frame(width: geometry.size.width / buttonFontSize * 10, height: geometry.size.width / buttonFontSize * 3, alignment: .center)
                                    .foregroundColor(hunterGreen)

                                Text("Menu").font(Font.custom("KronaOne-Regular", size: geometry.size.width / buttonFontSize)).foregroundColor(.white).onTapGesture {
                                    game.newGame(size: game.board.size)
                                    viewRouter.currentScreen = .welcome
                                    audioManager.playSound("MouseClick", type: "mp3")
                                }
                            }
                        }
                    }
                    .offset(y: 70)
                }
            }
            .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
            .background(Image(game.result == "You lose" ? "losing" : "background"))
            .scaleEffect(geometry.size.width / (scaleEffect * imageWidth))
            .opacity(showResult ? 1 : 0)
        }
    }
}
