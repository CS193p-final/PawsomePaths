//
//  HexGrid.swift
//  Hex
//
//  Created by Duong Pham on 2/14/21.
//

import SwiftUI

struct HexGrid: View {
    let cols: Int = 6
    let spacing: CGFloat = 10
    let imgsize = CGSize(width: 150, height: 150)
    
//    var cellView: CellView
    
    var body: some View {
        GeometryReader { geometry in
            let hexagonWidth = (geometry.size.width / 12) * cos(.pi / 6) * 2
            let gridItems = Array(repeating: GridItem(.fixed(hexagonWidth), spacing: spacing), count: cols)
            ScrollView(.vertical) {
                LazyVGrid(columns: gridItems, spacing: spacing) {
                    ForEach(0..<200) { idx in
                        VStack(spacing: 0) {
                            CellView(cell: Cell(id: idx), rect: geometry.size)
                                .clipShape(PolygonShape(sides: 6).rotation(Angle.degrees(90)))
                                .offset(x: isEvenRow(idx) ? 0: hexagonWidth / 2 + (spacing / 2))
                        }
                        //.frame(width: hexagonWidth, height: geometry.size.height / 6)
                        //.padding()
                    }
                }
                //.frame(width: (hexagonWidth + spacing) * CGFloat(cols - 1))
            }
        }
    }
    
    func isEvenRow(_ idx: Int) -> Bool { (idx / cols) % 2 == 0 }
}
