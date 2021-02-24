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
    var body: some View {
        if (twoPlayerGameView) {
            GameView(hexGame: TwoPlayersGame(name: "twoplayer"))
        } else if (singlePlayerGameView) {
            GameView(hexGame: SinglePlayerGame())
        } else {
            Button {
                twoPlayerGameView = true
            } label: {
                RoundedRectangle(cornerRadius: 10).opacity(0.3)
                   .frame(width: 150, height: 50, alignment: .center)
                   .overlay(Text("2 Player Game")).font(.headline)
            }
            
            Button {
                singlePlayerGameView = true
            } label: {
                RoundedRectangle(cornerRadius: 10).opacity(0.3)
                   .frame(width: 150, height: 50, alignment: .center)
                   .overlay(Text("Computer Game")).font(.headline)
            }
        }
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}
