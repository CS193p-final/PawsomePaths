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
    
    var body: some View {
        ZStack {
            HStack(spacing: 0) {
                ForEach (0..<cols, id: \.self) { cellIndex in
                    PolygonShape(sides: 6)
                        .stroke(lineWidth: 5)
                        .frame(width: frameWidth, height: frameHeight)
                        .foregroundColor(.red)
                }
            }
            Rectangle()
                .stroke(lineWidth: 5)
                .frame(width: frameWidth * CGFloat(cols - 1), height: frameHeight / 2, alignment: .leading).foregroundColor(.red)
            
            Rectangle()
                .frame(width: frameWidth * CGFloat(cols - 1), height: frameHeight / 2, alignment: .leading).foregroundColor(.white)
            HStack(spacing: 0) {
                ForEach (0..<cols, id: \.self) { cellIndex in
                    PolygonShape(sides: 6)
                        .frame(width: frameWidth, height: frameHeight)
                        .foregroundColor(.white)
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
