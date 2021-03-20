//
//  OnlineGameView.swift
//  Hex
//
//  Created by Duong Pham on 3/16/21.
//

import SwiftUI
import UIKit

struct OnlineGameView: View {
    @EnvironmentObject var viewRouter: ViewRouter
    
    @State var showResult = false
    @State private var showSettings = false
    @ObservedObject var hexGame: OnlineGame
    
    let red = Color(red: 0.9296875, green: 0.46, blue: 0.453)
    let blue = Color(red:0.39, green:0.55, blue:0.894)
    let hunterGreen = Color(red: 0.15625, green: 0.3125, blue: 0.1796875, opacity: 0.5)

    let backgroundColor = Color(red: 0.83984, green: 0.90625, blue: 0.7265625, opacity: 1)
    let buttonColor = Color(red: 0.1758, green: 0.515625, blue: 0.53901, opacity: 1)
    let buttonFontSize: CGFloat = 45
    let gameTitle: CGFloat = 20
    let playerTurnFontSize: CGFloat = 35
    
    var body: some View {
        let board = hexGame.board
        
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
                            Text("Back").font(Font.custom("PressStart2P-Regular", size: geometry.size.width / buttonFontSize))
                                .padding()
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .onTapGesture {
                                    playSound("MouseClick", type: "mp3", soundOn: hexGame.soundOn)
                                    hexGame.exitMatch()
                                    viewRouter.currentScreen = .welcome
                                }
                            
                            Image(systemName: "gearshape").imageScale(.large).foregroundColor(.white)
                                .onTapGesture {
                                    showSettings = true
                                    playSound("MouseClick", type: "mp3", soundOn: hexGame.soundOn)
                                }
                                .popover(isPresented: $showSettings) {
                                    onlineSettingsView(game: hexGame)
                                }
                                .padding()
                        }
                    }
                    .frame(width: geometry.size.width, height: geometry.size.width * 2 / gameTitle, alignment: .topLeading)
                    .padding(.bottom)
                    
                    Text("Hex Game")
                        .font(Font.custom("KronaOne-Regular", size: geometry.size.width / gameTitle))
                        .foregroundColor(Color(red: 0.82422, green: 0.37891, blue: 0.207, opacity: 1))
                    Text(board.playerTurn == hexGame.localPlayer ? "Your turn" : "Opponent's turn").foregroundColor(board.playerTurn == 1 ? red : blue)
                        .font(Font.custom("KronaOne-Regular", size: geometry.size.width / playerTurnFontSize))
                    .padding()

                        ZStack {
                            if (showResult == true && hexGame.result != "You lose" ) {
                                ForEach(0...8, id: \.self) {_ in
                                    FireworkRepresentable().position(x: CGFloat.random(in: 10 ... 2 * geometry.size.width), y: CGFloat.random(in: 10 ... geometry.size.height)).zIndex(-1)
                                }
                            }
                            HexGrid(hexGame.cellValues, cols: hexGame.board.size) { cell in
                                CellView(cell: cell).onTapGesture {
                                    playSound("move", type: "wav", soundOn: hexGame.soundOn)
                                    if !hexGame.gameEnded { // only when game has not ended
                                        hexGame.play(cellId: cell.id)
                                    }
                                }
                            }
                            .onChange(of: hexGame.gameEnded, perform: { value in
                                if hexGame.gameEnded {
                                    playSound(hexGame.result == "You lose" ? "lose" : "win", type: "mp3", soundOn: hexGame.soundOn)
                                }
                            })
                            .rotationEffect(Angle(degrees: 90))
                            .onReceive(self.hexGame.$board, perform: { newValue in
                                if newValue.winner != 0 {
                                    showResult = true
                                }
                            })
                            .popup(isPresented: $showResult) {
                                ZStack {
                                    resultReport(game: hexGame, soundOn: hexGame.soundOn, showResult: showResult)
                                }
                            }
                        }
                    newGameButton(game: hexGame, buttonFontSize: geometry.size.width / buttonFontSize, showResult: !showResult) // disabled when result view pop up
                    .foregroundColor(!showResult ? .blue : .gray)
                    .padding()
                }
            }
        }
        else {
            LoadingView(game: hexGame)
        }
        
    }
}

struct onlineSettingsView: View {
    @ObservedObject var game: GameMode
    @State private var showAlert: Bool = false
    private let lightCyan: Color = Color(red: 0.8555, green: 0.984375, blue: 0.9961, opacity: 0.8)
    private let queenBlue = Color(red: 0.26953, green: 0.41, blue: 0.5625)
    private let headerFontSize: CGFloat = 15

    var body: some View {
        Section(header: Text("Sound").font(Font.custom("KronaOne-Regular", size: headerFontSize))) {
            Button {
                game.toggleSound()
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 10).frame(width: 50, height: 50, alignment: .center) .foregroundColor(lightCyan)
                    Image(systemName: game.soundOn ? "speaker.wave.3" : "speaker").imageScale(.large)
                }
                .padding()
            }
        }
        .foregroundColor(queenBlue)

        Section(header: Text("Music").font(Font.custom("KronaOne-Regular", size: headerFontSize))) {
            Button {
                game.toggleMusic()
                if game.musicOn {
                    playMusic("musicBox", type: "mp3", musicOn: game.musicOn)
                } else {
                    stopMusic("musicBox", type: "mp3")
                }
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 10).frame(width: 50, height: 50, alignment: .center)    .foregroundColor(lightCyan)
                    Image(systemName: game.musicOn ? "music.note" : "play.slash").imageScale(.large)
                }
                .padding()
            }
        }
        .foregroundColor(queenBlue)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        OnlineGameView(hexGame: OnlineGame())
    }
}
