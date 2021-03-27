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
    private let darkBlueGray = Color(red: 0.3555, green: 0.3711, blue: 0.5898, opacity: 1)
    private let buttonFontSize: CGFloat = UIDevice.current.userInterfaceIdiom == .pad ? 60 : 30
    private let gameTitle: CGFloat = UIDevice.current.userInterfaceIdiom == .pad ? 20 : 10
    private let playerTurnFontSize: CGFloat = UIDevice.current.userInterfaceIdiom == .pad ? 50 : 25
    private let hPadding: CGFloat = 10
    private let vPadding: CGFloat = 5
    private let hunterGreen = Color(red: 0.15625, green: 0.3125, blue: 0.1796875, opacity: 0.5)
    private let backgroundColor = Color(red: 0.83984, green: 0.90625, blue: 0.7265625, opacity: 1)
    private let redExampleImages = ["redwin1.1", "redwin1.2", "redwin1.3", "itachicat"]
    private let blueExampleImages = ["bluewin1", "bluewin2", "bluewin3", "bluewin4", "itachicat"]
    private let redInstructions = ["", ""]
    @State private var currentRedIndex = 0
    @State private var currentBlueIndex = 0
    
    var body: some View {
        var tempBlueIndex = currentBlueIndex
        var tempRedIndex = currentRedIndex

        GeometryReader { geometry in
            ZStack {
                Rectangle().foregroundColor(backgroundColor).zIndex(-1).ignoresSafeArea()
                VStack {
                    ZStack {
                        Rectangle().foregroundColor(hunterGreen).ignoresSafeArea()
                        Text("Back")
                            .padding()
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .font(Font.custom("PressStart2P-Regular", size: geometry.size.width / playerTurnFontSize))
                            .onTapGesture {
                                viewRouter.currentScreen = .welcome
                                playSound("MouseClick", type: "mp3", soundOn: soundOn)
                            }
                    }
                    .frame(width: geometry.size.width, height: geometry.size.width * 2 / gameTitle, alignment: .topLeading)
                    
                    ScrollView(.vertical) {
                        Text("Players choose their color and take turn to place a hex on an unoccupied grid.")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(vPadding)

                        Text("First player to connect the opposite sides of their color wins the game.")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(vPadding)

                        Text("The four corners belong to both adjacent sides.")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(vPadding)

                        
                        Text("Red player connects the top and bottom sides of the board to win.")
                            .foregroundColor(red)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(vPadding)

                        Image(redExampleImages[currentRedIndex]).scaleEffect(geometry.size.width / 1712 ).frame(width: geometry.size.width, height: geometry.size.width)
                        
                        HStack {
                            Image(systemName: "arrow.left.circle").imageScale(.large)
                                .foregroundColor(red).onTapGesture {
                                    if currentRedIndex == 0 {
                                        currentRedIndex = 3
                                        tempRedIndex = 3
                                    } else {
                                        tempRedIndex -= 1
                                        currentRedIndex = tempRedIndex % 5
                                    }
                            }
                            Image(systemName: "arrow.right.circle").imageScale(.large)
                                .foregroundColor(red).onTapGesture {
                                    tempRedIndex += 1
                                    currentRedIndex = tempRedIndex % 4
                            }
                        }

                        Text("Blue player connects left and right sides of the board to win.")
                            .foregroundColor(blue)
                            .padding(vPadding)
                            .frame(maxWidth: .infinity, minHeight: geometry.size.width / playerTurnFontSize, alignment: .leading)
                        
                        Image(blueExampleImages[currentBlueIndex]).scaleEffect(geometry.size.width / 1712).frame(width: geometry.size.width, height: geometry.size.width)
                        
                        HStack {
                            Image(systemName: "arrow.left.circle").imageScale(.large).foregroundColor(blue).onTapGesture {
                                if currentBlueIndex == 0 {
                                    currentBlueIndex = 4
                                    tempBlueIndex = 4
                                } else {
                                    tempBlueIndex -= 1
                                    currentBlueIndex = tempBlueIndex % 5
                                }
                            }

                            Image(systemName: "arrow.right.circle").imageScale(.large).foregroundColor(blue).onTapGesture {
                                tempBlueIndex += 1
                                currentBlueIndex = tempBlueIndex % 5
                            }

                        }
                    }
                    .foregroundColor(darkBlueGray)
                    .font(Font.custom("KronaOne-Regular", size: geometry.size.width / playerTurnFontSize))
                }

            }
        }
    }
}
