//
//  GameView.swift
//  Hex
//
//  Created by Duong Pham on 2/14/21.
//

import SwiftUI

struct GameView: View {
    @EnvironmentObject var hexGame: GameMode
    @State private var showResult = false
    @State private var showSettings = false
    
    var body: some View {
        Text("Hex Game").bold().font(.headline)
        HStack {
            Text("Player 1 turn").foregroundColor(hexGame.board.playerTurn == 1 ? .red : .gray)
                .padding()
            Text("Player 2 turn").foregroundColor(hexGame.board.playerTurn == 2 ? .blue : .gray)
                .padding()
        }
        Image(systemName: "gearshape")
            .onTapGesture {
                showSettings = true
            }
            .popover(isPresented: $showSettings, content: {
                settingsView().environmentObject(hexGame)
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
        Button(action: {hexGame.newGame(size: 11) }) {
            RoundedRectangle(cornerRadius: 10).opacity(0.3)
                .frame(width: 100, height: 40, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                .overlay(Text("New Game"))
        }
    }
}

struct resultReport: View {
    var game: GameMode
    var body: some View {
        Text("\(game.result)").font(.headline)
    }
}

struct settingsView: View {
    @EnvironmentObject var game: GameMode
    var body: some View {
        Section(header: Text("Board size")) {
            Stepper(
                onIncrement: {
                    game.incrementSize()
                },
                onDecrement: {
                    game.decrementSize()
                },
                label: {
                    Text("")
                })
        }
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        Group {
//            GameView(hexGame: SinglePlayerGame())
//            GameView(hexGame: SinglePlayerGame())
//        }
//    }
//}
