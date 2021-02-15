//
//  HexGrid.swift
//  Hex
//
//  Created by Duong Pham on 2/14/21.
//

import SwiftUI

struct HexGrid: View {
    let cols: Int = 11
    let spacing: CGFloat = 1
    let imgsize = CGSize(width: 150, height: 150)
    
//    var cellView: CellView
    
    var body: some View {
        GeometryReader { geometry in
            let hexagonWidth = (geometry.size.width / 12) * cos(.pi / 6) * 2
            let gridItems = Array(repeating: GridItem(.fixed(hexagonWidth), spacing: -hexagonWidth/1.7), count: cols)
            ScrollView(.vertical) {
                LazyVGrid(columns: gridItems, spacing: 0) {
                    ForEach(0..<121) { idx in
                        VStack(spacing: 0) {
                            CellView(cell: Cell(id: idx), rect: geometry.size)
                                .clipShape(PolygonShape(sides: 6).rotation(Angle.degrees(90)))
                                .offset(x: offset(id: idx, hexagonWidth: hexagonWidth))
                        }
                    }
                }
            }
        }
    }
    
    func offset(id: Int, hexagonWidth: CGFloat) -> CGFloat {
        CGFloat(id / 11 + 1) * CGFloat(hexagonWidth / 4) - CGFloat(6 * hexagonWidth / 4)
    }
}

struct HexGrid_Preview: PreviewProvider {
    static var previews: some View {
        HexGrid()
    }
}
