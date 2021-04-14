//
//  LoadingVIew.swift
//  Hex
//
//  Created by Giang Nguyenn on 3/18/21.
//

import SwiftUI

struct LoadingView: View {
    @EnvironmentObject var viewRouter: ViewRouter
    
    @State var game: OnlineGame
    private let backgroundColor = Color(red: 0.83984, green: 0.90625, blue: 0.7265625, opacity: 1)
    private let buttonFontSize: CGFloat = UIDevice.current.userInterfaceIdiom == .pad ? 60 : 30
    private let gameTitle: CGFloat = UIDevice.current.userInterfaceIdiom == .pad ? 20 : 10
    private let playerTurnFontSize: CGFloat = UIDevice.current.userInterfaceIdiom == .pad ? 50 : 25
    private let hunterGreen = Color(red: 0.15625, green: 0.3125, blue: 0.1796875, opacity: 0.5)
    @AppStorage("musicOn") var musicOn = false
    @AppStorage("soundOn") var soundOn = false

    
    var body: some View {
        GeometryReader { geometry in
            Rectangle().foregroundColor(backgroundColor).ignoresSafeArea().zIndex(-1)
            Text("Back").font(Font.custom("PressStart2P-Regular", size: geometry.size.width / buttonFontSize))
                .foregroundColor(.black)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .onTapGesture {
                    playSound("MouseClick", type: "mp3", soundOn: soundOn)
            }
            if game.ready {
                VStack {
                    Text("Found you a worthy contender")
                        .font(Font.custom("PressStart2P-Regular", size: geometry.size.width / buttonFontSize))
                        .position(x: geometry.size.width / 2, y: geometry.size.height / 4)
                        .foregroundColor(.black)
                    Image("notalkweangy")
                        .scaleEffect( geometry.size.width / 2048)
                        .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                    Image(uiImage: UIImage(fromDiskWithFileName: "avatar")!)
                }
            } else {
                let random = Bool.random()
                Text("Back").font(Font.custom("PressStart2P-Regular", size: geometry.size.width / buttonFontSize))
                    .padding()
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity, alignment: .topLeading)
                    .onTapGesture {
                        playSound("MouseClick", type: "mp3", soundOn: true)
                        game.exitMatch()
                        viewRouter.currentScreen = .welcome
                    }
                VStack {
                    Image(random ? "redwiz" : "bluewiz").spinning().scaleEffect(geometry.size.width / 1350)
                    Text("Looking for a worthy contender...")
                        .font(Font.custom("PressStart2P-Regular", size: geometry.size.width / 40))
                        .foregroundColor(.black)
                }
                .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
            }
        }
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView(game: OnlineGame())
    }
}
