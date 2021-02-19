//
//  BlueBorder.swift
//  Hex
//
//  Created by Giang Nguyenn on 2/18/21.
//

import SwiftUI

struct BlueBorder: View {
    var cols: Int
    var frameSize: CGFloat
    var geometryWidth: CGFloat
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                ForEach (0..<cols, id: \.self) { cellIndex in
                    CellView(cell: Cell(id: cols * cols + 1, colorCode: 2))
                        .clipShape(PolygonShape(sides: 6))
                        .frame(width: frameSize, height: frameSize)
                        .offset(x: CGFloat(cellIndex) * (frameSize / 2) - frameSize / 4 - CGFloat(cols / 2) * frameSize)
                        .offset(y: frameSize / 4)
                }
                .zIndex(1)
            }
            Rectangle()
                .frame(width: frameSize * CGFloat(cols), height: frameSize / 2)
                .rotationEffect(Angle.degrees(64))
                .offset(x: CGFloat(cols / 2) * (frameSize / 2) - frameSize / 4 - CGFloat(cols / 2) * frameSize)
                .offset(y: frameSize / 4)
                .foregroundColor(.blue)
        }
    }
}

struct DiagonalLine: Shape {
    var frameSize: CGFloat
    
    func path(in rect: CGRect) -> Path {
        let topLeft = CGPoint(x: 0, y: 0)
        let topRight = CGPoint(x: CGFloat(cos(30 * Double.pi / 180)), y: 0)
        let bottomLeft = CGPoint(x: rect.width - CGFloat(cos(30 * Double.pi / 180)), y: rect.height)
        let bottomRight = CGPoint(x: rect.width, y: rect.height)
        var path = Path()
        path.move(to: topLeft)
        path.addLine(to: topRight)
        path.addLine(to: bottomRight)
        path.addLine(to: bottomLeft)
        path.addLine(to: topLeft)
        return path
    }
}

//struct BlueBorder_Previews: PreviewProvider {
//    static var previews: some View {
//        BlueBorder()
//    }
//}
