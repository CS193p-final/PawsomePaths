//
//  GameView.swift
//  Hex
//
//  Created by Duong Pham on 2/14/21.
//

import SwiftUI

struct GameView: View {
    @ObservedObject var hexGame: GameMode
    @State private var showResult = false
    
    var body: some View {
//        Text("Hex Game").bold().font(.headline)
//        HStack {
//            Text("Player 1 turn").foregroundColor(hexGame.board.playerTurn == 1 ? .red : .gray)
//                .padding()
//            Text("Player 2 turn").foregroundColor(hexGame.board.playerTurn == 2 ? .blue : .gray)
//                .padding()
//        }
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
        Button(action: hexGame.newGame) {
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            GameView(hexGame: SinglePlayerGame())
            GameView(hexGame: SinglePlayerGame())
        }
    }
}
