//
//  HowToPlayView.swift
//  Hex
//
//  Created by Duong Pham on 3/10/21.
//

import SwiftUI

struct HowToPlayView: View {
    @EnvironmentObject var viewRouter: ViewRouter
    
    @State var soundOn: Bool
    private let red = Color(red: 0.9296875, green: 0.46, blue: 0.453)
    private let blue = Color(red:0.39, green:0.55, blue:0.894)
    private let fontSize: CGFloat = 45
    private let gameTitle: CGFloat = 20
    private let hPadding: CGFloat = 10
    private let vPadding: CGFloat = 5
    private let hunterGreen = Color(red: 0.15625, green: 0.3125, blue: 0.1796875, opacity: 0.5)
    private let backgroundColor = Color(red: 0.83984, green: 0.90625, blue: 0.7265625, opacity: 1)
    private let redExampleImages = ["redwin1", "redwin2"]
    private let blueExampleImages = ["bluewin1", "bluewin2", "bluewin3"]
    @State private var currentRedIndex = 0
    @State private var currentBlueIndex = 0
    
    var body: some View {
        var tempBlueIndex = currentBlueIndex
        GeometryReader { geometry in
            ZStack {
                Rectangle().foregroundColor(backgroundColor).zIndex(-1).ignoresSafeArea()
                VStack {
                    ZStack {
                        Rectangle().foregroundColor(.white).ignoresSafeArea()
                        Text("Back")
                            .padding()
                            .foregroundColor(hunterGreen)
                            .frame(maxWidth: .infinity, alignment: .leading).font(Font.custom("PressStart2P-Regular", size: geometry.size.width / fontSize))
                            .onTapGesture {
                                viewRouter.currentScreen = .welcome
                                playSound("MouseClick", type: "mp3", soundOn: soundOn)
                            }
                    }
                    .frame(width: geometry.size.width, height: geometry.size.width * 2 / gameTitle, alignment: .topLeading)
                    ScrollView(.vertical) {
                        Text("Connect top and bottom side of the board to win")
                            .font(Font.custom("KronaOne-Regular", size: geometry.size.width / fontSize))
                            .foregroundColor(red)
                            .padding(.horizontal, hPadding)
                            .padding(.vertical, vPadding)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Image(redExampleImages[currentRedIndex]).scaleEffect(geometry.size.width / 1712 ).frame(width: geometry.size.width, height: geometry.size.width)
                        Image(systemName: "arrow.right.circle").imageScale(.large)
                            .foregroundColor(red).onTapGesture {
                            if currentRedIndex == 1 {
                                currentRedIndex = 0
                            } else {
                                currentRedIndex = 1
                            }
                        }
                        
                        Text("Connect left and right side of the board to win")
                            .font(Font.custom("KronaOne-Regular", size: geometry.size.width / fontSize))
                            .foregroundColor(blue)
                            .padding(.horizontal, hPadding)
                            .padding(.vertical, vPadding)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .onTapGesture {
                                print("\(geometry.size.width)")
                            }
                        Image(blueExampleImages[currentBlueIndex]).scaleEffect(geometry.size.width / 1712 ).frame(width: geometry.size.width, height: geometry.size.width)
                        Image(systemName: "arrow.right.circle").imageScale(.large).foregroundColor(blue).onTapGesture {
                            tempBlueIndex += 1
                            currentBlueIndex = tempBlueIndex % 3
                        }
                    }
                }
            }
        }
    }
}
