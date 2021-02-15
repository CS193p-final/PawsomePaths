//
//  CellView.swift
//  Hex
//
//  Created by Duong Pham on 2/14/21.
//

import SwiftUI

struct CellView: View {
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
    }
}
