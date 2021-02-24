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
                    PolygonShape(sides: 6)
                        .stroke(lineWidth: 5)
                        .frame(width: frameWidth, height: frameHeight)
                        .offset(x: CGFloat(cellIndex) * (frameWidth / 2) - frameWidth / 4 - CGFloat(cols / 2) * frameWidth)
                        .padding(.top, -frameHeight / 8)
                        .foregroundColor(.blue)
                }
            }
            Rectangle()
                .stroke(lineWidth: 5)
                .frame(width: frameHeight * CGFloat(cols - 1), height: frameHeight/2)
                .rotationEffect(Angle.degrees(60.3))
                .offset(x: cols % 2 == 0 ? xOffset - frameHeight/4 : xOffset)
                .foregroundColor(.blue)
            
            Rectangle()
                .frame(width: frameHeight * CGFloat(cols - 1), height: frameHeight/2)
                .rotationEffect(Angle.degrees(60.3))
                .offset(x: cols % 2 == 0 ? xOffset - frameHeight/4 : xOffset)
                .foregroundColor(.white)
            VStack(spacing: 0) {
                ForEach (0..<cols, id: \.self) { cellIndex in
                    PolygonShape(sides: 6)
                        .frame(width: frameWidth, height: frameHeight)
                        .offset(x: CGFloat(cellIndex) * (frameWidth / 2) - frameWidth / 4 - CGFloat(cols / 2) * frameWidth)
                        .padding(.top, -frameHeight / 8)
                        .foregroundColor(.white)
                }
            }
        }
    }
    var xOffset: CGFloat {
        (CGFloat(cols / 2) * frameHeight / 2 - frameWidth/5 - CGFloat(cols / 2) * frameWidth)
    }
}

struct BlueBorder_Previews: PreviewProvider {
    static var previews: some View {
        BlueBorder(cols: 7, frameHeight: 50, frameWidth: 50)
    }
}
