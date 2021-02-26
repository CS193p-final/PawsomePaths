//
//  GameView.swift
//  Hex
//
//  Created by Duong Pham on 2/14/21.
//

import SwiftUI
import UIKit

struct GameView: View {
    @State private var welcomeView = false
    @State private var showResult = false
    @State private var showSettings = false
    @ObservedObject var hexGame: GameMode
    
    var body: some View {
        let board = hexGame.board
        if (welcomeView) {
            WelcomeView()
        } else {
            Text("Back")
                .padding()
                .foregroundColor(.blue)
                .frame(maxWidth: .infinity, alignment: .leading)
                .onTapGesture {
                    welcomeView = true
                }
            
            Text("Hex Game").bold().font(.headline)
            
            HStack {
                Text("Player 1 turn").foregroundColor(board.playerTurn == 1 ? .red : .gray)
                    .padding()
                Text("Player 2 turn").foregroundColor(board.playerTurn == 2 ? .blue : .gray)
                    .padding()
            }
            
            Image(systemName: "gearshape")
                .onTapGesture {
                    showSettings = true
                }
                .popover(isPresented: $showSettings, content: {
                    settingsView(game: hexGame)
                })
            
            ZStack {
                HexGrid(hexGame.cellValues, cols: hexGame.board.size) { cell in
                    CellView(cell: cell)
                        .onTapGesture {
                            hexGame.play(cellId: cell.id)
                            if hexGame.gameEnded {
                                showResult = true
                            }
                        }
                }
            }
            .popover(isPresented: $showResult) {
                resultReport(game: hexGame)
            }
            
            Button(action: {hexGame.newGame(size: hexGame.board.size) }) {
                RoundedRectangle(cornerRadius: 10).opacity(0.3)
                    .frame(width: 100, height: 40, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    .overlay(Text("New Game"))
            }
        }
    }
}

struct resultReport: View {
    var game: GameMode
    var body: some View {
        Image(systemName: "ladybug")
        Text("\(game.result)").font(.headline)
        FireworkRepresentable()
    }
}

struct settingsView: View {
    @ObservedObject var game: GameMode
    @State private var showAlert: Bool = false
    var body: some View {
        Section(header: Text("Board size")) {
            Stepper(
                onIncrement: {
                    game.incrementSize()
                    if game.board.size == 11 {
                        showAlert = true
                    }
                },
                onDecrement: {
                    game.decrementSize()
                    if game.board.size == 3 {
                        showAlert = true
                    }
                },
                label: {
                    Text("\(game.board.size)")
                })
                .alert(isPresented: $showAlert) { () -> Alert in
                    Alert(title: Text("Invalid board size"), message: Text("Board size cannot be less than 3x3 or greater than 11x11"), dismissButton: Alert.Button.cancel())
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            GameView(hexGame: SinglePlayerGame())
            GameView(hexGame: SinglePlayerGame())
        }
    }
}
