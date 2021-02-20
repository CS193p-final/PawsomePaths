//
//  BlueBorder.swift
//  Hex
//
//  Created by Giang Nguyenn on 2/18/21.
//

import SwiftUI

struct BlueBorder: View {
    var cols: Int
    var frameHeight: CGFloat
    var frameWidth: CGFloat
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                ForEach (0..<cols, id: \.self) { cellIndex in
                    CellView(cell: Cell(id: cols * cols + 1, colorCode: 2))
                        .clipShape(PolygonShape(sides: 6))
                        .frame(width: frameWidth, height: frameHeight)
                        .offset(x: CGFloat(cellIndex) * (frameWidth / 2) - frameWidth / 4 - CGFloat(cols / 2) * frameWidth)
                        .offset(y: frameHeight / 4)
                        .padding(.vertical, -frameHeight / 8)
                }
            }
            Rectangle()
                .frame(width: frameWidth * CGFloat(cols - 1), height: frameWidth / 2)
                .rotationEffect(Angle.degrees(60))
                .offset(x: cols % 2 == 0 ? (CGFloat(cols / 2) * (frameWidth / 2) - frameWidth / 4 - CGFloat(cols / 2) * frameWidth) - frameWidth/4 : CGFloat(cols / 2) * (frameWidth / 2) - frameWidth / 4 - CGFloat(cols / 2) * frameWidth)
                .offset(y: frameWidth / 4)
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
