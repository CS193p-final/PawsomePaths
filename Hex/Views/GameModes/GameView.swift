
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
    var modalManager = ModalManager()

    @State private var showResult = false
    @State private var showSettingsForPhone = false
    @State private var showSettingsForPad = false
    @ObservedObject var hexGame: GameMode
    @State var continueGame: Bool?
    var isIpad = UIDevice.current.userInterfaceIdiom == .pad

    private let red = Color(red: 0.9296875, green: 0.46, blue: 0.453)
    private let blue = Color(red:0.39, green:0.55, blue:0.894)
    private let hunterGreen = Color(red: 0.15625, green: 0.3125, blue: 0.1796875, opacity: 0.5)
    private let titleColor = Color(red: 0.82422, green: 0.37891, blue: 0.207, opacity: 1)
    private let backgroundColor = Color(red: 0.83984, green: 0.90625, blue: 0.7265625, opacity: 1)
    private let buttonColor = Color(red: 0.1758, green: 0.515625, blue: 0.53901, opacity: 1)
    

    
    var body: some View {
        let buttonFontSize: CGFloat = isIpad ? 60 : 30
        let gameTitle: CGFloat = isIpad ? 20 : 10
        let playerTurnFontSize: CGFloat = isIpad ? 50 : 25
        
        GeometryReader { geometry in
            Rectangle().foregroundColor(backgroundColor).ignoresSafeArea().zIndex(-2)
                .onAppear{
                    playMusic("musicBox", type: "mp3", musicOn: hexGame.musicOn)
                    hexGame.board = (continueGame != nil && continueGame == true) ? hexGame.board : GameBoard(size: hexGame.board.size, musicOn: hexGame.board.musicOn, soundOn: hexGame.board.soundOn)
                    showResult = false
                }
                .onDisappear {
                    stopMusic("musicBox", type: "mp3")
                }
            ZStack {
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
                                    viewRouter.currentScreen = .welcome
                                }
                            Image(systemName: "gearshape").imageScale(.large) .foregroundColor(.white)
                                .onTapGesture {
                                    if !isIpad {
                                        if modalManager.modal.position == .closed {
                                            showSettingsForPhone = true
                                            self.modalManager.openModal()
                                        }
                                    } else {
                                        showSettingsForPad = !showSettingsForPad
                                    }
                                    playSound("MouseClick", type: "mp3", soundOn: hexGame.soundOn)
                                }
                                .onAppear {
                                    self.modalManager.newModal(position: .closed) {
                                        settingsView(game: hexGame)
                                    }
                                }
                                .popover(isPresented: $showSettingsForPad) {
                                    settingsView(game: hexGame)
                                }
                                .padding()
                        }
                    }
                    .frame(width: geometry.size.width, height: geometry.size.width / gameTitle, alignment: .topLeading)
                    .padding(.bottom)
                    
                    Text("Hex Game")
                        .font(Font.custom("KronaOne-Regular", size: geometry.size.width / gameTitle))
                        .foregroundColor(titleColor)
                    Text(hexGame.playerTurn).foregroundColor(hexGame.board.playerTurn == 1 ? red : blue)
                        .font(Font.custom("KronaOne-Regular", size: geometry.size.width / playerTurnFontSize))

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
                            .onReceive(self.hexGame.$board, perform: { newValue in
                                if newValue.winner != 0 {
                                    showResult = true
                                }
                            })
                            .rotationEffect(Angle.degrees(90))
                            .popup(isPresented: $showResult) {
                                ZStack {
                                    resultReport(game: hexGame, soundOn: hexGame.soundOn, showResult: showResult)
                                }
                            }
                        }
                    newGameButton(game: hexGame, buttonFontSize: geometry.size.width / buttonFontSize, showResult: !showResult) // disabled when result view pop up
                    .foregroundColor(!showResult ? .blue : .gray)
                    .padding()
                    .zIndex(-1)
                }
                ModalAnchorView().environmentObject(modalManager)
            }
        }
    }
}


struct newGameButton: View {
    var game: GameMode
    let buttonFontSize: CGFloat
    var showResult: Bool
    private let hunterGreen = Color(red: 0.15625, green: 0.3125, blue: 0.1796875, opacity: 0.5)
    
    var body: some View {
        Button(action: {
            let soundOn = game.soundOn
            let musicOn = game.musicOn
            showResult ? game.newGame(size: game.board.size) : nil
            if game.soundOn != soundOn {
                game.toggleSound()
            }
            if game.musicOn != musicOn {
                game.toggleMusic()
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

struct resultReport: View {
    @EnvironmentObject var viewRouter: ViewRouter
    var game: GameMode
    @State var soundOn: Bool
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
                        newGameButton(game: game, buttonFontSize: geometry.size.width / buttonFontSize, showResult: showResult)
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

struct settingsView: View {
    @ObservedObject var game: GameMode
    @State private var showAlert: Bool = false
    private let lightCyan: Color = Color(red: 0.8555, green: 0.984375, blue: 0.9961, opacity: 0.8)
    private let queenBlue = Color(red: 0.26953, green: 0.41, blue: 0.5625)
    private let wildBlueYonder = Color(red: 0.71875, green: 0.71875, blue: 0.8164, opacity: 1)
    private let headerFontSize: CGFloat = 15
    @EnvironmentObject var modalManager: ModalManager

    var body: some View {
        VStack {
            Section(header: Text("Board size").padding()) {
                Stepper(
                    onIncrement: {
                        game.incrementSize()
                        if game.board.size == game.maxSize {
                            showAlert = true
                        }
                    },
                    onDecrement: {
                        game.decrementSize()
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
                        game.toggleSound()
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 10).frame(width: 50, height: 50, alignment: .center) .foregroundColor(lightCyan)
                            Image(systemName: game.soundOn ? "speaker.wave.3" : "speaker").imageScale(.large)
                        }
                    }
                }

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
                            RoundedRectangle(cornerRadius: 10).frame(width: 50, height: 50, alignment: .center)
                                .foregroundColor(lightCyan)
                            Image(systemName: game.musicOn ? "music.note" : "play.slash").imageScale(.large)
                        }
                    }
                }
            }
        }
        .padding()
        .foregroundColor(queenBlue)
        .font(Font.custom("KronaOne-Regular", size: headerFontSize))
        .background(wildBlueYonder)
    }
}
