
//
//  GameView.swift
//  Hex
//
//  Created by Duong Pham on 2/14/21.
//
import SwiftUI
import UIKit

struct GameView: View {
    @EnvironmentObject var viewRouter: ViewRouter
    @EnvironmentObject var audioManager: AudioManager
    @EnvironmentObject var modalManager: ModalManager
    
    @State private var showResult = false
    @State private var showSettingsForPad = false
    @ObservedObject var hexGame: GameMode
    @State var continueGame: Bool?
    @AppStorage("musicOn") var musicOn = false
    @AppStorage("soundOn") var soundOn = false
    
    var isIpad = UIDevice.current.userInterfaceIdiom == .pad

    private let red = Color(red: 0.9296875, green: 0.46, blue: 0.453)
    private let blue = Color(red:0.39, green:0.55, blue:0.894)
    private let titleColor = Color(red: 0.82422, green: 0.37891, blue: 0.207, opacity: 1)
    private let backgroundColor = Color(red: 0.83984, green: 0.90625, blue: 0.7265625, opacity: 1)
    private let buttonColor = Color(red: 0.1758, green: 0.515625, blue: 0.53901, opacity: 1)
    
    var body: some View {
        let buttonFontSize: CGFloat = isIpad ? 60 : 30
        let gameTitle: CGFloat = isIpad ? 30 : 15
        let playerTurnFontSize: CGFloat = isIpad ? 50 : 25
        
        GeometryReader { geometry in
            Rectangle().foregroundColor(backgroundColor).ignoresSafeArea().zIndex(-2)
                .onAppear{
                    audioManager.playMusic("musicBox", type: "mp3")
                    hexGame.board = (continueGame != nil && continueGame == true) ? hexGame.board : GameBoard(size: hexGame.board.size)
                    showResult = false
                }
                .onDisappear {
                    audioManager.stopMusic("musicBox", type: "mp3")
                }
            ZStack {
                VStack {
                    ZStack {
                        Rectangle().ignoresSafeArea().foregroundColor(Color.hunterGreen)
                        HStack {
                            Text("Back").font(Font.custom("PressStart2P-Regular", size: geometry.size.width / buttonFontSize))
                                .padding()
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .onTapGesture {
                                    audioManager.playSound("MouseClick", type: "mp3")
                                    viewRouter.currentScreen = .welcome
                                }
                            Image(systemName: "gearshape").imageScale(.large) .foregroundColor(.white)
                                .onTapGesture {
                                    if !isIpad {
                                        if modalManager.modal.position == .closed {
                                            self.modalManager.openModal()
                                        }
                                    } else {
                                        showSettingsForPad = !showSettingsForPad
                                    }
                                    audioManager.playSound("MouseClick", type: "mp3")
                                }
                                .onAppear {
                                    self.modalManager.newModal(position: .closed) {
                                        settingsView(game: hexGame).environmentObject(audioManager)
                                    }
                                }
                                .popover(isPresented: $showSettingsForPad) {
                                    settingsView(game: hexGame)
                                        .environmentObject(audioManager)
                                }
                                .padding()
                        }
                    }
                    .frame(width: geometry.size.width, height: geometry.size.width / gameTitle, alignment: .topLeading)
                    .padding(.bottom)
                    
                    Text("Pawsome Paths")
                        .font(Font.custom("KronaOne-Regular", size: geometry.size.width / gameTitle))
                        .foregroundColor(titleColor)
                        .padding()
                    Text(hexGame.playerTurn).foregroundColor(hexGame.board.playerTurn == 1 ? red : blue)
                        .font(Font.custom("KronaOne-Regular", size: geometry.size.width / playerTurnFontSize))

                        ZStack {
                            HexGrid(hexGame.cellValues, cols: hexGame.board.size) { cell in
                                CellView(cell: cell).onTapGesture {
                                    audioManager.playSound("move", type: "wav")
                                    if !hexGame.gameEnded { // only when game has not ended
                                        hexGame.play(cellId: cell.id)
                                    }
                                }
                            }
                            .onChange(of: hexGame.gameEnded, perform: { value in
                                if hexGame.gameEnded {
                                    audioManager.playSound(hexGame.result == "You lose" ? "lose" : "win", type: "mp3")
                                }
                            })
                            .onReceive(self.hexGame.$board, perform: { newValue in
                                if newValue.winner != 0 {
                                    showResult = true
                                }
                            })
                            .rotationEffect(Angle.degrees(90))
                            .popup(isPresented: $showResult) {
                                ZStack {
                                    ResultReport(localGame: hexGame, showResult: showResult)
                                }
                            }
                        }
                    NewGameButton(localGame: hexGame, buttonFontSize: geometry.size.width / buttonFontSize, showResult: !showResult) // disabled when result view pop up
                    .foregroundColor(!showResult ? .blue : .gray)
                    .padding()
                    .zIndex(-1)
                    .opacity(showResult ? 0.5 : 1)
                }
                ModalAnchorView().environmentObject(modalManager)
            }
        }
    }
}

struct settingsView: View {
    @ObservedObject var game: GameMode
    @EnvironmentObject var audioManager : AudioManager
    @State private var showAlert: Bool = false
    
    private let headerFontSize: CGFloat = 15

    var body: some View {
        VStack {
            Section(header: Text("Board size").padding()) {
                Stepper(
                    onIncrement: {
                        game.incrementSize()
                        // workaround bug
                        // have to address the bug in the future
                        audioManager.toggleSound()
                        audioManager.toggleSound()

                        if game.board.size == game.maxSize {
                            showAlert = true
                        }
                    },
                    onDecrement: {
                        game.decrementSize()
                        // workaround bug
                        // have to address bug better in the future
                        audioManager.toggleSound()
                        audioManager.toggleSound()

                        if game.board.size == game.minSize {
                            showAlert = true
                        }
                    },
                    label: {
                        Text("\(game.board.size)")
                    })
                    .alert(isPresented: $showAlert) { () -> Alert in
                        Alert(title: Text("Invalid board size"), message: Text("Board size cannot be less than \(game.minSize) or greater than \(game.maxSize)"), dismissButton: Alert.Button.cancel())
                    }
            }
            HStack {
                Section(header: Text("Sound").font(Font.custom("KronaOne-Regular", size: headerFontSize))) {
                    Button {
                        audioManager.toggleSound()
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 10).frame(width: 50, height: 50, alignment: .center) .foregroundColor(Color.lightCyan)
                            Image(systemName: audioManager.soundOn ? "speaker.wave.3" : "speaker").imageScale(.large)
                        }
                    }
                }

                Section(header: Text("Music").font(Font.custom("KronaOne-Regular", size: headerFontSize))) {
                    Button {
                        audioManager.toggleMusic()
                        if audioManager.musicOn {
                            audioManager.playMusic("musicBox", type: "mp3")
                        } else {
                            audioManager.stopMusic("musicBox", type: "mp3")
                        }
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 10).frame(width: 50, height: 50, alignment: .center)
                                .foregroundColor(Color.lightCyan)
                            Image(systemName: audioManager.musicOn ? "music.note" : "play.slash").imageScale(.large)
                        }
                    }
                }
            }
        }
        .padding()
        .foregroundColor(Color.queenBlue)
        .font(Font.custom("KronaOne-Regular", size: headerFontSize))
        .background(Color.wildBlueYonder)
    }
}
