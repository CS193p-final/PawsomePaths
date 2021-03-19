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
    @State private var twoPlayerGameView = false
    @State private var singlePlayerGameView = false
    @State private var onlineGameView = false
    @State private var howToPlayView = false
    @State private var showSingleActionSheet = false
    @State private var showTwoPlayerActionSheet = false
    @State private var continueSingleGame: Bool?
    @State private var continueTwoPlayerGame: Bool?
    private let backgroundColor = Color(red: 0.83984, green: 0.90625, blue: 0.7265625, opacity: 1)

    @AppStorage("logged") var logged = false
    @AppStorage("email") var email = ""
    @AppStorage("firstName") var firstName = ""
    
    var body: some View {
        ZStack {
            Rectangle().foregroundColor(backgroundColor).zIndex(-1).ignoresSafeArea()
            VStack {
                if (twoPlayerGameView) {
                    GameView(hexGame: TwoPlayersGame(name: "twoPlayer"), continueGame: continueTwoPlayerGame)
                } else if (singlePlayerGameView) {
                    GameView(hexGame: SinglePlayerGame(name: "singlePlayer"), continueGame: continueSingleGame)
                } else if (onlineGameView) {
                    OnlineGameView(hexGame: OnlineGame())
                }
                else if (howToPlayView) {
                    HowToPlayView(soundOn: true)
                }
                else {
                    if logged {
                        Text("Welcome \(firstName)")
                        let avatar = UIImage(fromDiskWithFileName: "avatar")
                        if avatar != nil {
                            Image(uiImage: avatar!)
                                .padding()
                                .position(y: 0)
                        }
                    } else {
                        UserSection().frame(alignment: .top)
                            .padding()
                    }
                    
                    Button {
                        playSound("MouseClick", type: "mp3", soundOn: true)
                        showTwoPlayerActionSheet = true
                    } label: {
                        RoundedRectangle(cornerRadius: 10).opacity(0.3)
                            .frame(width: 250, height: 75, alignment: .center)
                            .overlay(Text("2 Players"))
                            .font(Font.custom("KronaOne-Regular", size: 20))
                            .foregroundColor(Color(red: 0.1758, green: 0.515625, blue: 0.53901, opacity: 1))
                    }
                    .actionSheet(isPresented: $showTwoPlayerActionSheet) {
                        ActionSheet(title: Text("Two Players Game"), buttons: [
                            .default(Text("New Game")) {
                                twoPlayerGameView = true
                                continueTwoPlayerGame = false
                            },
                            .default(Text("Contiue")) {
                                twoPlayerGameView = true
                                continueTwoPlayerGame = true
                            }
                        ])
                    }
                    
                    Button {
                        playSound("MouseClick", type: "mp3", soundOn: true)
                        showSingleActionSheet = true
                    } label: {
                        RoundedRectangle(cornerRadius: 10).opacity(0.3)
                            .frame(width: 250, height: 75, alignment: .center)
                            .overlay(Text("Single Player"))
                            .font(Font.custom("KronaOne-Regular", size: 20))
                            .foregroundColor(Color(red: 0.1758, green: 0.515625, blue: 0.53901, opacity: 1))
                    }
                    .actionSheet(isPresented: $showSingleActionSheet) {
                        ActionSheet(title: Text("Single Player Game"), buttons: [
                            .default(Text("New Game")) {
                                singlePlayerGameView = true
                                continueSingleGame = false
                            },
                            .default(Text("Contiue")) {
                                singlePlayerGameView = true
                                continueSingleGame = true
                            }
                        ])
                    }
                    
                    Button {
                        playSound("MouseClick", type: "mp3", soundOn: true)
                        onlineGameView = true
                    } label: {
                        RoundedRectangle(cornerRadius: 10).opacity(0.3)
                            .frame(width: 250, height: 75, alignment: .center)
                            .overlay(Text("Play Online"))
                            .font(Font.custom("KronaOne-Regular", size: 20))
                            .foregroundColor(Color(red: 0.1758, green: 0.515625, blue: 0.53901, opacity: 1))
                    }

                    Button {
                        playSound("MouseClick", type: "mp3", soundOn: true)
                        howToPlayView = true
                    } label: {
                        RoundedRectangle(cornerRadius: 10).opacity(0.3)
                            .frame(width: 250, height: 75, alignment: .center)
                            .overlay(Text("How To Play"))
                            .font(Font.custom("KronaOne-Regular", size: 20))
                            .foregroundColor(Color(red: 0.1758, green: 0.515625, blue: 0.53901, opacity: 1))
                    }
                    
                    FBButton()
                        .frame(width: 250, height: 75, alignment: .center)
                }
            }
        }
    }
}


struct UserSection: View {
    var body: some View {
        Image(systemName: "person.circle.fill").imageScale(.large)
            .frame(width: 100, height: 100, alignment: .topLeading)
    }
}

//struct activitySheet: View {
//    @State var isPresented: Bool
//
//}
