//
//  RedBorder.swift
//  Hex
//
//  Created by Giang Nguyenn on 2/18/21.
//

import SwiftUI

struct RedBorder: View {
    var cols: Int
    var frameHeight: CGFloat
    var frameWidth: CGFloat
    var lineWidth: CGFloat = 10
    
    var body: some View {
        let backgroundColor = Color(red: 0.83984, green: 0.90625, blue: 0.7265625, opacity: 1)
        let red = Color(red: 0.9296875, green: 0.46, blue: 0.453)

        ZStack {
            HStack(spacing: 0) {
                ForEach (0..<cols, id: \.self) { cellIndex in
                    PolygonShape(sides: 6)
                        .stroke(lineWidth: lineWidth)
                        .frame(width: frameWidth, height: frameHeight)
                        .foregroundColor(red)

                }
            }
            Rectangle()
                .stroke(lineWidth: lineWidth)
                .frame(width: frameWidth * CGFloat(cols - 1), height: frameHeight / 2, alignment: .leading).foregroundColor(red)

            
            Rectangle()
                .frame(width: frameWidth * CGFloat(cols - 1) + (lineWidth * 2), height: frameHeight / 2, alignment: .leading)
                .foregroundColor(backgroundColor)

            HStack(spacing: 0) {
                ForEach (0..<cols, id: \.self) { cellIndex in
                    PolygonShape(sides: 6)
                        .frame(width: frameWidth, height: frameHeight)
                        .foregroundColor(backgroundColor)
                }
            }
        }
    }
}
//
//struct RedBorder_Previews: PreviewProvider {
//    static var previews: some View {
//        RedBorder()
//    }
//}
