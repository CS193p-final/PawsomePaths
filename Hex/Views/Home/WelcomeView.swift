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
    @State private var showSingleActionSheet = false
    @State private var showTwoPlayerActionSheet = false
    @State private var noConnectionAlert = false

    @AppStorage("anonymousUID") var anonymousUID = ""
    @AppStorage("UID") var uid = ""
    @AppStorage("logged") var logged = false
    @AppStorage("email") var email = ""
    @AppStorage("firstName") var firstName = ""
    
    
    private let backgroundColor = Color(red: 0.83984, green: 0.90625, blue: 0.7265625, opacity: 1)
    private var widthRatio = CGFloat(UIDevice.current.userInterfaceIdiom == .pad ? 1/2 : 1)
    private var heightRatio = CGFloat(1/8)
    private var buttonFontSizeRatio = CGFloat(1/30)
    private let hunterGreen = Color(red: 0.15625, green: 0.3125, blue: 0.1796875, opacity: 0.5)
    private let gameTitle: CGFloat = UIDevice.current.userInterfaceIdiom == .pad ? 20 : 10
    private let playerTurnFontSize: CGFloat = UIDevice.current.userInterfaceIdiom == .pad ? 50 : 25

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Rectangle().foregroundColor(backgroundColor).zIndex(-1).ignoresSafeArea()
                    .onAppear {
                        WelcomeView.networkMonitor.startMonitoring()
                        print("monitored")
                    }
                Image(systemName: "line.horizontal.3.circle.fill")
                    .imageScale(.large)
                    .foregroundColor(hunterGreen)
                    .position(x: 20, y: 20)

                VStack {
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
                    }
                    //.frame(width: geometry.size.width, height: geometry.size.width * 2 / gameTitle, alignment: .center)
                    
                    // Two Player Mode Button
                    Button {
                        playSound("MouseClick", type: "mp3", soundOn: true)
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
                        playSound("MouseClick", type: "mp3", soundOn: true)
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
                        playSound("MouseClick", type: "mp3", soundOn: true)
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
                        playSound("MouseClick", type: "mp3", soundOn: true)
                        viewRouter.currentScreen = .howToPlay
                    } label: {
                        rectButton("How to Play", width: geometry.size.width, height: geometry.size.height)
                    }
                    
                    // Connect with Facebook button
                    FBButton(width: geometry.size.width, height: geometry.size.height)
                    // Invite friends button
                    InviteButton(width: geometry.size.width, height: geometry.size.height)
                }
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


struct UserSection: View {
    var body: some View {
        Image("guestava")
            .scaleEffect(UIDevice.current.userInterfaceIdiom == .pad ? 90/673 : 85/673)
    }
}
