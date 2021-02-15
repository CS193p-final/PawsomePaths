//
//  CellView.swift
//  Hex
//
//  Created by Duong Pham on 2/14/21.
//

import SwiftUI

struct CellView: View {
    @ObservedObject var cell: Cell
    var body: some View {
        Rectangle()
            .onTapGesture {
                cell.changeColor()
            }
            .foregroundColor(cell.color)
            .overlay(Text("\(cell.id / 6), \(cell.id % 6)"))
    }
}
