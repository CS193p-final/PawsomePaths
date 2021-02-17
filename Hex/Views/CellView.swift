//
//  CellView.swift
//  Hex
//
//  Created by Duong Pham on 2/14/21.
//

import SwiftUI

struct CellView: View {
    var cell: Cell
    var body: some View {
        Rectangle()
            .foregroundColor(cell.color)
    }
}
