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
        PolygonShape(sides: 6)
            .foregroundColor(cell.color)
    }
}
