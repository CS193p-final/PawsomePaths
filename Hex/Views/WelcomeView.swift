//
//  WelcomeView.swift
//  Hex
//
//  Created by Giang Nguyenn on 2/16/21.
//

import SwiftUI

struct WelcomeView: View {
    @State private var twoPlayerGameView = false
    @State private var singlePlayerGameView = false
    @State private var howToPlayView = false
    
    var body: some View {
        if (twoPlayerGameView) {
            GameView(hexGame: TwoPlayersGame(name: "twoPlayer"))
        } else if (singlePlayerGameView) {
            GameView(hexGame: SinglePlayerGame(name: "singlePlayer"))
        } else if (howToPlayView) {
            HowToPlayView(soundOn: true)
        }
        else {
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
                howToPlayView = true
            } label: {
                RoundedRectangle(cornerRadius: 10).opacity(0.3)
                    .frame(width: 250, height: 75, alignment: .center)
                    .overlay(Text("How To Play"))
                    .font(Font.custom("KronaOne-Regular", size: 20))
                    .foregroundColor(Color(red: 0.1758, green: 0.515625, blue: 0.53901, opacity: 1))
            }

        }
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}
