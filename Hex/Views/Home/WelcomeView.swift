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
    @AppStorage("logged") var logged = false
    @AppStorage("email") var email = ""
    
    var body: some View {
        if (twoPlayerGameView) {
            GameView(hexGame: TwoPlayersGame(name: "twoPlayer"))
        } else if (singlePlayerGameView) {
            GameView(hexGame: SinglePlayerGame(name: "singlePlayer"))
        } else if (onlineGameView) {
            OnlineGameView(hexGame: OnlineGame())
        }
        else if (howToPlayView) {
            HowToPlayView(soundOn: true)
        }
        else {
            if logged {
                Text("Welcome \(email)")
            }
            UserSection().frame(alignment: .top)
            Button {
                twoPlayerGameView = true
                playSound("MouseClick", type: "mp3", soundOn: true)
            } label: {
                RoundedRectangle(cornerRadius: 10).opacity(0.3)
                    .frame(width: 250, height: 75, alignment: .center)
                    .overlay(Text("2 Players"))
                    .font(Font.custom("KronaOne-Regular", size: 20))
                    .foregroundColor(Color(red: 0.1758, green: 0.515625, blue: 0.53901, opacity: 1))
            }
            
            Button {
                playSound("MouseClick", type: "mp3", soundOn: true)
                singlePlayerGameView = true
            } label: {
                RoundedRectangle(cornerRadius: 10).opacity(0.3)
                    .frame(width: 250, height: 75, alignment: .center)
                    .overlay(Text("Single Player"))
                    .font(Font.custom("KronaOne-Regular", size: 20))
                    .foregroundColor(Color(red: 0.1758, green: 0.515625, blue: 0.53901, opacity: 1))
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

struct UserSection: View {
    var body: some View {
        Image(systemName: "person.circle.fill").imageScale(.large)
            .frame(width: 100, height: 100, alignment: .topLeading)
    }
}
