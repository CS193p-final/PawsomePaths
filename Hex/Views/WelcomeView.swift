//
//  WelcomeView.swift
//  Hex
//
//  Created by Giang Nguyenn on 2/16/21.
//

import SwiftUI

struct WelcomeView: View {
    var body: some View {
        NavigationView {
            VStack {
                NavigationLink(
                    destination: GameView(hexGame: GameViewModel()),
                    label: {
                        RoundedRectangle(cornerRadius: 10).opacity(0.3)
                            .frame(width: 150, height: 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                            .overlay(Text("New 2 Player Game")).font(.headline)
                    })
                NavigationLink(
                    destination: GameView(hexGame: GameViewModel()),
                    label: {
                        RoundedRectangle(cornerRadius: 10).opacity(0.3)
                            .frame(width: 150, height: 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                            .overlay(Text("New Computer Game")).font(.headline)
                    })
            }
        }
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}
