//
//  CellView.swift
//  Hex
//
//  Created by Duong Pham on 2/14/21.
//

import SwiftUI

struct CellView: View {
    let id: Int
    @State private var color: Color = .white
    var body: some View {
        Rectangle()
            .foregroundColor(color)
            .onTapGesture {
                if color == .red {
                    color = .blue
                }
                else {
                    color = .red
                }
            }
            .overlay(Text("\(id / 6), \(id % 6)"))
    }
}
