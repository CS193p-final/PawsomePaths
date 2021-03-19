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
    private let red = Color(red: 0.9296875, green: 0.46, blue: 0.453)
    private let blue = Color(red:0.39, green:0.55, blue:0.894)
    private let fontSize: CGFloat = 45
    private let hPadding: CGFloat = 10
    private let vPadding: CGFloat = 5
    private let hunterGreen = Color(red: 0.15625, green: 0.3125, blue: 0.1796875, opacity: 0.5)
    
    var body: some View {
        if welcomeView {
            WelcomeView()
        } else {
            GeometryReader { geometry in
                VStack {
                    Text("Back")
                        .padding()
                        .foregroundColor(hunterGreen)
                        .frame(maxWidth: .infinity, alignment: .leading).font(Font.custom("PressStart2P-Regular", size: geometry.size.width / fontSize))
                        .onTapGesture {
                            welcomeView = true
                            playSound("MouseClick", type: "mp3", soundOn: soundOn)
                        }
                    Text("Connect top and bottom side of the board to win")
                        .font(Font.custom("KronaOne-Regular", size: geometry.size.width / fontSize))
                        .foregroundColor(red)
                        .padding(.horizontal, hPadding)
                        .padding(.vertical, vPadding)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    Text("Connect left and right side of the board to win")
                        .font(Font.custom("KronaOne-Regular", size: geometry.size.width / fontSize))
                        .foregroundColor(blue)
                        .padding(.horizontal, hPadding)
                        .padding(.vertical, vPadding)
                        .frame(maxWidth: .infinity, alignment: .leading)

                }
            }
        }
    }
}
