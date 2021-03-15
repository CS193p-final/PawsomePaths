//
//  HowToPlayView.swift
//  Hex
//
//  Created by Duong Pham on 3/10/21.
//

import SwiftUI

struct HowToPlayView: View {
    @State private var welcomeView = false
    @State var soundOn: Bool
    let red = Color(red: 0.9296875, green: 0.46, blue: 0.453)
    let blue = Color(red:0.39, green:0.55, blue:0.894)
    let fontSize: CGFloat = 15
    let hPadding: CGFloat = 10
    let vPadding: CGFloat = 5

    var body: some View {
        if welcomeView {
            WelcomeView()
        } else {
            GeometryReader { geometry in
                VStack {
                    Text("Back")
                        .padding()
                        .foregroundColor(.blue)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .onTapGesture {
                            welcomeView = true
                            playSound("MouseClick", type: "mp3", soundOn: soundOn)
                        }
                    Text("Connect top and bottom side of the board to win")
                        .font(Font.custom("KronaOne-Regular", size: fontSize))
                        .foregroundColor(red)
                        .padding(.horizontal, hPadding)
                        .padding(.vertical, vPadding)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    Text("Connect left and right side of the board to win")
                        .font(Font.custom("KronaOne-Regular", size: fontSize))
                        .foregroundColor(blue)
                        .padding(.horizontal, hPadding)
                        .padding(.vertical, vPadding)
                        .frame(maxWidth: .infinity, alignment: .leading)

                }
            }
        }
    }
}
