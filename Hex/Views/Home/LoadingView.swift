//
//  LoadingView.swift
//  Hex
//
//  Created by Giang Nguyenn on 3/18/21.
//

import SwiftUI

struct LoadingView: View {
    var game: OnlineGame
    @AppStorage("logged") var logged = false
    @AppStorage("email") var email = ""
    var body: some View {
        if game.ready {
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)

        } else {
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
        }
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView(game: OnlineGame())
    }
}
