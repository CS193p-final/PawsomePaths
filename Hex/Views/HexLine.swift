//
//  HexLine.swift
//  Hex
//
//  Created by Giang Nguyenn on 2/16/21.
//

import SwiftUI

struct HexLine: View {
    var color: Int
    var horizontal: Bool
    var body: some View {
        if horizontal {
            HStack {
                ForEach(0..<11) { cell in
                    CellView(cell: Cell(id: 200, colorCode: color))
                }
            }
        } else {
            VStack {
                ForEach(0..<11) { cell in
                    CellView(cell: Cell(id: 200, colorCode: color))
                }
            }
        }
    }
}

//struct HexLine_Previews: PreviewProvider {
//    static var previews: some View {
//        HexLine()
//    }
//}
