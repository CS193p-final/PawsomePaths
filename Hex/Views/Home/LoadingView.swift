//
//  LoadingVIew.swift
//  Hex
//
//  Created by Giang Nguyenn on 3/18/21.
//

import SwiftUI

struct LoadingView: View {
    @State var game: OnlineGame
    private let backgroundColor = Color(red: 0.83984, green: 0.90625, blue: 0.7265625, opacity: 1)
    let buttonFontSize: CGFloat = 40
    @State var welcomeView: Bool = false
    private let hunterGreen = Color(red: 0.15625, green: 0.3125, blue: 0.1796875, opacity: 0.5)

    
    var body: some View {
        if welcomeView {
            WelcomeView()
        } else {
            GeometryReader { geometry in
                Rectangle().foregroundColor(backgroundColor).ignoresSafeArea().zIndex(-1)
                Text("Back").font(Font.custom("PressStart2P-Regular", size: geometry.size.width / buttonFontSize))
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .onTapGesture {
                        welcomeView = true
                        playSound("MouseClick", type: "mp3", soundOn: game.soundOn)
                }
                if game.ready {
                    VStack {
                        Text("Found you a worthy contender")
                            .font(Font.custom("PressStart2P-Regular", size: geometry.size.width / buttonFontSize))
                            .position(x: geometry.size.width / 2, y: geometry.size.height / 4)
                        Image("notalkweangy")
                            .scaleEffect( geometry.size.width / 2048)
                            .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                        Image(uiImage: UIImage(fromDiskWithFileName: "avatar")!)
                    }
                } else {
                    ZStack {
                        Text("Looking for a worthy contender...")
                            .font(Font.custom("PressStart2P-Regular", size: geometry.size.width / buttonFontSize))
                            .position(x: geometry.size.width / 2, y: geometry.size.height / 4)
                        Image("notalkmeangy")
                            .scaleEffect( geometry.size.width / 2048)
                            .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                    }
                }
            }
        }
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView(game: OnlineGame())
    }
}
