//
//  CellView.swift
//  Hex
//
//  Created by Duong Pham on 2/14/21.
//

import SwiftUI

struct CellView: View {
    @ObservedObject var cell: Cell
    var rect: CGSize
    
    var body: some View {
        Rectangle()
            .onTapGesture {
                cell.changeColor()
            }
            .foregroundColor(cell.color)
            .overlay(Text("\(cell.id / 11), \(cell.id % 11)"))
            .frame(width: rect.width / 16.5, height: rect.width / 16.5)
    }
}
