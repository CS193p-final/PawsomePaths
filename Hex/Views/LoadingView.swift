//
//  LoadingView.swift
//  Hex
//
//  Created by Giang Nguyenn on 3/16/21.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        GeometryReader { geometry in
            let random = Bool.random()
            Image(random ? "redwiz" : "bluewiz").spinning().imageScale(.large)
        }
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
}
