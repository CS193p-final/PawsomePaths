//
//  RedBorder.swift
//  Hex
//
//  Created by Giang Nguyenn on 2/18/21.
//

import SwiftUI

struct RedBorder: View {
    var cols: Int
    var frameSize: CGFloat
    var body: some View {
        ZStack {
            HStack(spacing: 0) {
                ForEach (0..<cols, id: \.self) { cell in
                    CellView(cell: Cell(id: cols * cols + 1, colorCode: 1))
                        .clipShape(PolygonShape(sides: 6))
                        .frame(width: frameSize, height: frameSize)
                }
            }
            Rectangle()
                .frame(width: frameSize * CGFloat(cols), height: frameSize / 2, alignment: .leading).foregroundColor(.red)
        }

    }
}
//
//struct RedBorder_Previews: PreviewProvider {
//    static var previews: some View {
//        RedBorder()
//    }
//}
