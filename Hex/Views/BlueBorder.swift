//
//  BlueBorder.swift
//  Hex
//
//  Created by Giang Nguyenn on 2/18/21.
//

import SwiftUI
import UIKit

struct BlueBorder: View {
    var cols: Int
    var frameHeight: CGFloat
    var frameWidth: CGFloat
    var lineWidth: CGFloat = 10
    
    
    var body: some View {
        let blue = Color(red:0.39, green:0.55, blue:0.894)
        let backgroundColor = Color(red: 0.83984, green: 0.90625, blue: 0.7265625, opacity: 1)

        ZStack {
            VStack(spacing: 0) {
                ForEach (0..<cols, id: \.self) { cellIndex in
                    PolygonShape(sides: 6)
                        .stroke(lineWidth: lineWidth)
                        .frame(width: frameWidth, height: frameHeight)
                        .offset(x: CGFloat(cellIndex) * (frameWidth / 2) - frameWidth / 4 - CGFloat(cols / 2) * frameWidth)
                        .padding(.top, -frameHeight / 8)
                        .foregroundColor(blue)

                }
            }
            Rectangle()
                .stroke(lineWidth:lineWidth)
                .frame(width: frameHeight * CGFloat(cols - 1), height: frameHeight/2)
                .rotationEffect(Angle.degrees(60))
                .offset(x: cols % 2 == 0 ? xOffset - frameHeight/4 : xOffset)
                .foregroundColor(blue)

            
            Rectangle()
                .frame(width: frameHeight * CGFloat(cols - 1) + lineWidth * 2, height: frameHeight/2)
                .rotationEffect(Angle.degrees(60))
                .offset(x: cols % 2 == 0 ? xOffset - frameHeight/4 : xOffset)
                .foregroundColor(backgroundColor)
            
            VStack(spacing: 0) {
                ForEach (0..<cols, id: \.self) { cellIndex in
                    PolygonShape(sides: 6)
                        .frame(width: frameWidth, height: frameHeight)
                        .offset(x: CGFloat(cellIndex) * (frameWidth / 2) - frameWidth / 4 - CGFloat(cols / 2) * frameWidth)
                        .padding(.top, -frameHeight / 8)
                        .foregroundColor(backgroundColor)
                }
            }
        }
    }
    var xOffset: CGFloat {
        (CGFloat(cols / 2) * frameHeight / 2 - frameWidth/5 - CGFloat(cols / 2) * frameWidth)
    }
}
