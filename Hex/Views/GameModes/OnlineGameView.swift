//
//  OnlineGameView.swift
//  Hex
//
//  Created by Duong Pham on 3/16/21.
//

import SwiftUI
import UIKit

struct OnlineGameView: View {
    @State private var welcomeView = false
    @State var showResult = false
    @State private var showSettings = false
    @ObservedObject var hexGame: OnlineGame
    
    let red = Color(red: 0.9296875, green: 0.46, blue: 0.453)
    let blue = Color(red:0.39, green:0.55, blue:0.894)
    let hunterGreen = Color(red: 0.15625, green: 0.3125, blue: 0.1796875, opacity: 0.5)

    let backgroundColor = Color(red: 0.83984, green: 0.90625, blue: 0.7265625, opacity: 1)
    let buttonColor = Color(red: 0.1758, green: 0.515625, blue: 0.53901, opacity: 1)
    let buttonFontSize: CGFloat = 18
    let gameTitle: CGFloat = 36
    let playerTurnFontSize: CGFloat = 20
    
    var body: some View {
        let board = hexGame.board
        Text(hexGame.ready ? "Ready" : "Not ready")
        if (welcomeView) {
            WelcomeView()
        }
        else {
            if hexGame.ready {
                GeometryReader { geometry in
                    Rectangle().foregroundColor(backgroundColor).ignoresSafeArea().zIndex(-2)
                        .onAppear{
                            playMusic("musicBox", type: "mp3", musicOn: hexGame.musicOn)
                        }
                        .onDisappear {
                            stopMusic("musicBox", type: "mp3")
                        }
                    VStack {
                        ZStack {
                            Rectangle().ignoresSafeArea().foregroundColor(hunterGreen)
                            HStack {
                                Text("Back").font(Font.custom("KronaOne-Regular", size: buttonFontSize))
                                    .padding()
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .onTapGesture {
                                        welcomeView = true
                                        playSound("MouseClick", type: "mp3", soundOn: hexGame.soundOn)
                                    }
                                
                                Image(systemName: "gearshape").imageScale(.large)                            .foregroundColor(.white)
                                    .onTapGesture {
                                        showSettings = true
                                    }
                                    .popover(isPresented: $showSettings) {
                                        settingsView(game: hexGame)
                                            .frame(width: 250, alignment: .top)
                                    }
                                    .padding()
                            }
                        }
                        .frame(width: geometry.size.width, height: 50, alignment: .topLeading)
                        
                        Text("Hex Game")
                            .font(Font.custom("KronaOne-Regular", size: gameTitle))
                            .foregroundColor(Color(red: 0.82422, green: 0.37891, blue: 0.207, opacity: 1))
                        Text(board.playerTurn == hexGame.localPlayer ? "Your turn" : "Opponent's turn").foregroundColor(board.playerTurn == 1 ? red : blue)
                        .font(Font.custom("KronaOne-Regular", size: playerTurnFontSize))
                        .padding()

                            ZStack {
                                if (showResult == true && hexGame.result != "Computer wins" ) {
                                    ForEach(0...8, id: \.self) {_ in
                                        FireworkRepresentable().position(x: CGFloat.random(in: 10 ... 2 * geometry.size.width), y: CGFloat.random(in: 10 ... geometry.size.height)).zIndex(-1)
                                    }
                                }
                                HexGrid(hexGame.cellValues, cols: hexGame.board.size) { cell in
                                    CellView(cell: cell).onTapGesture {
                                        playSound("move", type: "mp3", soundOn: hexGame.soundOn)
                                        if !hexGame.gameEnded { // only when game has not ended
                                            hexGame.play(cellId: cell.id)
                                        }
                                    }
                                }
                                .rotationEffect(Angle(degrees: 90))
                                .onReceive(self.hexGame.$board, perform: { newValue in
                                    if newValue.winner != 0 {
                                        showResult = true
                                    }
                                    //print("board is updated. Game ended = \(showResult)")
                                })
                                .popup(isPresented: $showResult) {
                                    ZStack {
                                        resultReport(game: hexGame, soundOn: hexGame.soundOn, showResult: showResult)
                                        VStack {
                                            newGameButton(game: hexGame, showResult: showResult)
                                            Button {
                                                welcomeView = true
                                                hexGame.newGame(size: hexGame.board.size)
                                            } label: {
                                                ZStack {
                                                    RoundedRectangle(cornerRadius: 10)
                                                        .foregroundColor(hunterGreen)
                                                        .frame(width: 130, height: 50, alignment: .center)
                                                    Text("Menu").font(Font.custom("KronaOne-Regular", size: buttonFontSize)).foregroundColor(.white)
                                                }
                                            }
                                        }
                                        .padding(.top, 275)
                                    }
                                }
                            }
                    newGameButton(game: hexGame, showResult: !showResult) // disabled when result view pop up
                        .foregroundColor(!showResult ? .blue : .gray)
                        .padding()
                    }
                }
            }
            else {
                LoadingView()
            }
        }
    }
}
