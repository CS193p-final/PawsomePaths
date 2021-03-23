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
    @EnvironmentObject var viewRouter: ViewRouter
    
    @State private var showSingleActionSheet = false
    @State private var showTwoPlayerActionSheet = false
    
    @AppStorage("logged") var logged = false
    @AppStorage("email") var email = ""
    @AppStorage("firstName") var firstName = ""
    
    private let backgroundColor = Color(red: 0.83984, green: 0.90625, blue: 0.7265625, opacity: 1)
    private var widthRatio = CGFloat(UIDevice.current.userInterfaceIdiom == .pad ? 1/2 : 1)
    private var heightRatio = CGFloat(1/8)
    private var buttonFontSizeRatio = CGFloat(1/30)
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Rectangle().foregroundColor(backgroundColor).zIndex(-1).ignoresSafeArea()
                VStack {
                    //Text(email)
                    if logged {
                        VStack {
                            Text("Welcome \(firstName)")
                            let avatar = UIImage(fromDiskWithFileName: "avatar")
                            if avatar != nil {
                                Image(uiImage: avatar!).clipShape(Circle())
                            }
                        }
                    } else {
                        Text("Welcome guest")
                        UserSection()
                            .frame(width: 80, height: 80)
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
                                viewRouter.currentScreen = .twoPlayersGame(false)
                            },
                            .default(Text("Continue")) {
                                viewRouter.currentScreen = .twoPlayersGame(true)
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
                                viewRouter.currentScreen = .singlePlayerGame(false)
                            },
                            .default(Text("Contiue")) {
                                viewRouter.currentScreen = .singlePlayerGame(false)
                            }
                        ])
                    }
                    
                    Button {
                        playSound("MouseClick", type: "mp3", soundOn: true)
                        viewRouter.currentScreen = .onlineGame
                    } label: {
                        RoundedRectangle(cornerRadius: 10).opacity(0.3)
                            .frame(width: 250, height: 75, alignment: .center)
                            .overlay(Text("Play Online"))
                            .font(Font.custom("KronaOne-Regular", size: 20))
                            .foregroundColor(Color(red: 0.1758, green: 0.515625, blue: 0.53901, opacity: 1))
                    }

                    Button {
                        playSound("MouseClick", type: "mp3", soundOn: true)
                        viewRouter.currentScreen = .howToPlay
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
        Image("guestava")
            .scaleEffect(90/673)
            .onTapGesture {
                print("guestava")
            }
    }
}
