//
//  HowToPlayView.swift
//  Hex
//
//  Created by Duong Pham on 3/10/21.
//

import SwiftUI

struct HowToPlayView: View {
    @State private var welcomeView = false
    let fontSize: CGFloat = 15
    var body: some View {
        if welcomeView {
            WelcomeView()
        } else {
            VStack {
                Text("Back")
                    .padding()
                    .foregroundColor(.blue)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .onTapGesture {
                        welcomeView = true
                        playSound("MouseClick", type: "mp3")
                    }
                Text("Connect top and bottom side of the board to win")
                    .font(Font.custom("KronaOne-Regular", size: fontSize))
                    .foregroundColor(Color(red: 0.82422, green: 0.37891, blue: 0.207, opacity: 1))
            }
        }
    }
}
