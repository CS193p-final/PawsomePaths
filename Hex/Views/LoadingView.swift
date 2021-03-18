//
//  LoadingView.swift
//  Hex
//
//  Created by Giang Nguyenn on 3/16/21.
//

import SwiftUI

struct LoadingView: View {
    private let buttonFontSize: CGFloat = 45
    @State private var welcomeView = false
   
    var body: some View {
        if welcomeView {
            WelcomeView()
        } else {
            GeometryReader { geometry in
                let random = Bool.random()
                Text("Back").font(Font.custom("PressStart2P-Regular", size: geometry.size.width / buttonFontSize))
                    .padding()
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity, alignment: .topLeading)
                    .onTapGesture {
                        welcomeView = true
                        playSound("MouseClick", type: "mp3", soundOn: true)
                    }
                VStack {
                    Image(random ? "redwiz" : "bluewiz").spinning().scaleEffect(geometry.size.width / 1350)
                    Text("Loading...").font(Font.custom("PressStart2P-Regular", size: geometry.size.width / 30))
                }
                .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
            }
        }
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
}
