//
//  WelcomeView.swift
//  Hex
//
//  Created by Giang Nguyenn on 2/16/21.
//

import SwiftUI
import FBSDKLoginKit
import FirebaseAuth

struct WelcomeView: View {
    static var networkMonitor = NetworkConnection()
    @EnvironmentObject var viewRouter: ViewRouter
    @EnvironmentObject var audioManager: AudioManager
    @State private var showSingleActionSheet = false
    @State private var showTwoPlayerActionSheet = false
    @State private var noConnectionAlert = false
    @State private var showMenuForIpad = false

    @AppStorage("anonymousUID") var anonymousUID = ""
    @AppStorage("UID") var uid = ""
    @AppStorage("logged") var logged = false
    @AppStorage("email") var email = ""
    @AppStorage("firstName") var firstName = ""
    @AppStorage("musicOn") var musicOn = false
    @AppStorage("soundOn") var sound = false
    
    private var modalManager = ModalManager()
    private let isPad = UIDevice.current.userInterfaceIdiom == .pad
    private let backgroundColor = Color(red: 0.83984, green: 0.90625, blue: 0.7265625, opacity: 1)
    private var widthRatio = CGFloat(UIDevice.current.userInterfaceIdiom == .pad ? 1/2 : 1)
    private var heightRatio = CGFloat(1/8)
    private var buttonFontSizeRatio = CGFloat(1/30)
    private let hunterGreen = Color(red: 0.15625, green: 0.3125, blue: 0.1796875, opacity: 0.5)
    private let gameTitle: CGFloat = UIDevice.current.userInterfaceIdiom == .pad ? 20 : 10
    private let playerTurnFontSize: CGFloat = UIDevice.current.userInterfaceIdiom == .pad ? 50 : 25
    private let wildBlueYonder = Color(red: 0.71875, green: 0.71875, blue: 0.8164, opacity: 1)

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Rectangle().foregroundColor(backgroundColor).zIndex(-1).ignoresSafeArea()
                    .onAppear {
                        WelcomeView.networkMonitor.startMonitoring()
                        print("monitored")
                    }
                
                Image(systemName: "line.horizontal.3.circle.fill")
                .scaleEffect(isPad ? 2 : 1.5)
                .foregroundColor(hunterGreen)
                .position(x: isPad ? 40 : 20, y: isPad ? 40: 20)
                .onTapGesture {
                        showMenuForIpad = !showMenuForIpad
                }
                .popover(isPresented: $showMenuForIpad) {
                    ZStack {
                        Menu(width: geometry.size.width, height: geometry.size.height)
                        Rectangle().foregroundColor(wildBlueYonder)
                            .zIndex(-1)
                    }
                }

                VStack {
                    // User name and avatar
                    if logged {
                        VStack {
                            Text("Welcome \(firstName)").foregroundColor(.black)
                            let avatar = UIImage(fromDiskWithFileName: "avatar")
                            if avatar != nil {
                                Image(uiImage: avatar!).clipShape(Circle())
                                    .frame(width: 80, height: 80)
                            }
                        }.onTapGesture {
                            viewRouter.currentScreen = .friendList
                        }
                    } else {
                        Text("Welcome guest").foregroundColor(.black)
                        UserSection()
                            .frame(width: 80, height: 80)
                    }
                    
                    // Two Player Mode Button
                    Button {
                        audioManager.playSound("MouseClick", type: "mp3")
                        showTwoPlayerActionSheet = true
                    } label: {
                        rectButton("Two Players", width: geometry.size.width, height: geometry.size.height)
                    }
                    .actionSheet(isPresented: $showTwoPlayerActionSheet) {
                        ActionSheet(title: Text("Two Players Game"), buttons: [
                            .default(Text("New Game")) {
                                viewRouter.currentScreen = .twoPlayersGame(false)
                            },
                            .default(Text("Continue")) {
                                viewRouter.currentScreen = .twoPlayersGame(true)
                            },
                            .default(Text("Cancel")) {
                                showTwoPlayerActionSheet = false
                            }
                        ])
                    }
                    
                    // Single Player Mode Button
                    Button {
                        audioManager.playSound("MouseClick", type: "mp3")
                        showSingleActionSheet = true
                    } label: {
                        rectButton("Single Player", width: geometry.size.width, height: geometry.size.height)
                    }
                    .actionSheet(isPresented: $showSingleActionSheet) {
                        ActionSheet(title: Text("Single Player Game"), buttons: [
                            .default(Text("New Game")) {
                                viewRouter.currentScreen = .singlePlayerGame(false)
                            },
                            .default(Text("Continue")) {
                                viewRouter.currentScreen = .singlePlayerGame(true)
                            },
                            .default(Text("Cancel")) {
                                showSingleActionSheet = false
                            }
                        ])
                    }
                    
                    // Play Online Mode Button
                    Button {
                        audioManager.playSound("MouseClick", type: "mp3")
                        if WelcomeView.networkMonitor.isReachable || WelcomeView.networkMonitor.isReachableCellular {
                            viewRouter.currentScreen = .onlineGame
                        } else {
                            noConnectionAlert = true
                        }
                        print("Connection status:  \(WelcomeView.networkMonitor.isReachable) and cellular: \(WelcomeView.networkMonitor.isReachableCellular)")
                    } label: {
                        rectButton("Play Online", width: geometry.size.width, height: geometry.size.height)
                    }
                    .alert(isPresented: $noConnectionAlert) { () -> Alert in
                        Alert(title: Text("No Connection"), message: Text("You need Internet connection to play online. Please check your connection and try again"), dismissButton: .cancel())
                    }
                    
                    // How to Play Screen Button
                    Button {
                        audioManager.playSound("MouseClick", type: "mp3")
                        viewRouter.currentScreen = .howToPlay
                    } label: {
                        rectButton("How to Play", width: geometry.size.width, height: geometry.size.height)
                    }
                }
                ModalAnchorView().environmentObject(modalManager)
            }
        }
        .onAppear {
            if !logged {
                // try to sign-in with anonymous authentication
                if anonymousUID != "" {
                    print("User already logged in anonymously. UID = \(anonymousUID)")
                    uid = anonymousUID
                    return
                }
                Auth.auth().signInAnonymously { (result, error) in
                    print("Signed in anonymously")
                    anonymousUID = Auth.auth().currentUser!.uid
                    uid = anonymousUID
                }
            }
        }
    }
}

func rectButton(_ message: String, width: CGFloat, height: CGFloat) -> some View {
    let isPad = UIDevice.current.userInterfaceIdiom == .pad
    return ZStack {
        RoundedRectangle(cornerRadius: 10).opacity(0.3)
            .frame(width: isPad ? width / 3 : width / 1.5, height: isPad ? height / 14 : height / 9, alignment: .center)
            .overlay(Text(message))
            .font(Font.custom("KronaOne-Regular", size: 20))
            .foregroundColor(Color(red: 0.1758, green: 0.515625, blue: 0.53901, opacity: 1))
            //.padding(UIDevice.current.userInterfaceIdiom == .pad ? 5 : 0)
    }
}

struct Menu: View {
    @EnvironmentObject var audioManager: AudioManager
    var width: CGFloat
    var height: CGFloat
    private let lightCyan: Color = Color(red: 0.8555, green: 0.984375, blue: 0.9961, opacity: 0.8)
    private let queenBlue = Color(red: 0.26953, green: 0.41, blue: 0.5625)
    private let headerFontSize: CGFloat = 15
    private let wildBlueYonder = Color(red: 0.71875, green: 0.71875, blue: 0.8164, opacity: 1)
    
    var body: some View {
        VStack {
            HStack {
                Section(header: Text("Sound")) {
                    Button {
                        audioManager.toggleSound()
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 10).frame(width: 50, height: 50, alignment: .center) .foregroundColor(lightCyan)
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
                                .foregroundColor(lightCyan)
                            Image(systemName: audioManager.musicOn ? "music.note" : "play.slash").imageScale(.large)
                        }
                    }
                }
            }
            // Connect with Facebook button
            FBButton(width: width, height: height)
            // Invite friends button
            InviteButton(width: width, height: height)
            // Show friend list
            FriendsButton(width: width, height: height)
        }
        .foregroundColor(queenBlue)
        .padding()
        .font(Font.custom("KronaOne-Regular", size: headerFontSize))
    }
}

struct UserSection: View {
    var body: some View {
        Image("guestava")
            .scaleEffect(UIDevice.current.userInterfaceIdiom == .pad ? 90/673 : 85/673)
    }
}
