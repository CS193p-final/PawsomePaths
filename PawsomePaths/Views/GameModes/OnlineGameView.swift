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
    @EnvironmentObject var audioManager: AudioManager
    @EnvironmentObject var modalManager: ModalManager

    @State var showResult = false
    @State private var showSettingsForPad = false
    @State private var showNotice = false
    
    @ObservedObject var hexGame: OnlineGame
    @AppStorage("musicOn") var musicOn = false
    @AppStorage("soundOn") var soundOn = false
    @AppStorage("firstName") var firstName = ""
    var isIpad = UIDevice.current.userInterfaceIdiom == .pad
    
    let red = Color(red: 0.9296875, green: 0.46, blue: 0.453)
    let blue = Color(red:0.39, green:0.55, blue:0.894)
    let black = Color.black
    private let titleColor = Color(red: 0.82422, green: 0.37891, blue: 0.207, opacity: 1)
    let backgroundColor = Color(red: 0.83984, green: 0.90625, blue: 0.7265625, opacity: 1)
    let buttonColor = Color(red: 0.1758, green: 0.515625, blue: 0.53901, opacity: 1)
    
    var body: some View {
        let buttonFontSize: CGFloat = isIpad ? 60 : 30
        let gameTitle: CGFloat = isIpad ? 30 : 15
        let _: CGFloat = isIpad ? 50 : 25
        let imageFrame : CGFloat = 70
        var timer: Timer = Timer()
        
        if hexGame.ready {
            GeometryReader { geometry in
                Rectangle().foregroundColor(backgroundColor).ignoresSafeArea().zIndex(-2)
                    .onAppear{
                        audioManager.playMusic("musicBox", type: "mp3")
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
                                        hexGame.exitMatch()
                                        viewRouter.currentScreen = .welcome
                                    }
                                
                                Image(systemName: "gearshape").imageScale(.large).foregroundColor(.white)
                                    .onTapGesture {
                                        if !isIpad {
                                            if modalManager.modal.position == .closed {
                                                self.modalManager.peekModal()
                                            }
                                        } else {
                                            showSettingsForPad = !showSettingsForPad
                                        }
                                        audioManager.playSound("MouseClick", type: "mp3")
                                    }.onAppear {
                                        self.modalManager.newModal(position: .closed) {
                                            onlineSettingsView().environmentObject(audioManager)
                                        }
                                    }
                                    .popover(isPresented: $showSettingsForPad) {
                                        onlineSettingsView().environmentObject(audioManager)
                                    }
                                    .padding()
                            }
                        }
                        .frame(width: geometry.size.width, height: geometry.size.width / gameTitle, alignment: .topLeading)
                        .padding(.bottom)
                        
                        HStack() {
                            if hexGame.localPlayerAvatar != nil {
                                Image(uiImage: hexGame.localPlayerAvatar!)
                                    .clipShape(Circle())
                                    .frame(width: imageFrame, height: imageFrame, alignment: .center)
                            } else {
                                Image(hexGame.localPlayer == 1 ? "redava" : "guestava")
                                    .frame(width: imageFrame, height: imageFrame, alignment: .center)
                                    .scaleEffect(50/673)
                            }

                            Text(hexGame.localPlayer == hexGame.board.playerTurn ? "Your turn" : "\(hexGame.remotePlayerName)'s turn")
                                .padding(.horizontal)
                                .font(Font.custom("PressStart2P-Regular", size: isIpad ?  20 : 10))
                                .foregroundColor(hexGame.board.playerTurn == 2 ? blue : red)
                                .frame(width: geometry.size.width / 2, alignment: .center)
                            
                            if hexGame.remotePlayerAvatar != nil {
                                Image(uiImage: hexGame.remotePlayerAvatar!)
                                    .clipShape(Circle())
                                    .frame(width: imageFrame, height: imageFrame, alignment: .center)
                            } else {
                                Image(hexGame.localPlayer == 1 ? "guestava" : "redava")
                                    .scaleEffect(50/673)
                                    .frame(width: imageFrame, height: imageFrame, alignment: .center)
                            }
                        }
                        .padding(.top)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .foregroundColor(.black)
                        
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
                            .rotationEffect(Angle(degrees: 90))
                            .scaleEffect(isIpad ? 0.9 : 1)
                            .onReceive(self.hexGame.$board, perform: { newValue in
                                if newValue.winner > 0 { // normal win
                                    showResult = true
                                }
                                if newValue.winner < 0 && !hexGame.gameEnded { // win by one player disconnected from the game
                                    showResult = true
                                }
                            })
                            .popup(isPresented: $showResult) {
                                ZStack {
                                    ResultReport(onlineGame: hexGame, showResult: showResult)
                                }
                            }
                        }
                    }
                    ModalAnchorView().environmentObject(modalManager)
                }
            }
        }
        else {
            LoadingView(game: hexGame)
                .onAppear {
                    timer = Timer.scheduledTimer(withTimeInterval: 20.0, repeats: false) { timer in
                        showNotice = true
                        timer.invalidate()
                   }
                }
                .onDisappear {timer.invalidate()}
                .alert(isPresented: $showNotice) {
                    Alert(title: Text("No match found"), message: Text("Yikes, seems like you're the only on online at this moment. Please exit and try again"), primaryButton:
                            .default(Text("OK"), action: {
                                hexGame.exitMatch()
                                viewRouter.currentScreen = .welcome
                            })
                    , secondaryButton: .cancel()
                )
            }
        }
    }
}



struct onlineSettingsView: View {
    @State private var showAlert: Bool = false
    private let headerFontSize: CGFloat = 15
    @EnvironmentObject var audioManager: AudioManager

    var body: some View {
        HStack {
            Section(header: Text("Sound")) {
                Button {
                    audioManager.toggleSound()
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10).frame(width: 50, height: 50, alignment: .center) .foregroundColor(Color.lightCyan)
                        Image(systemName: audioManager.soundOn ? "speaker.wave.3" : "speaker").imageScale(.large)
                    }
                }
            }

            Section(header: Text("Music")) {
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
        .foregroundColor(Color.queenBlue)
        .padding()
        .font(Font.custom("KronaOne-Regular", size: headerFontSize))
        .background(Color.wildBlueYonder)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        OnlineGameView(hexGame: OnlineGame()).environmentObject(AudioManager())
    }
}
