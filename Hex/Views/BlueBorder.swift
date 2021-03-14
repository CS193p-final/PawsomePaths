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
        
        Rectangle()
            .frame(width: frameHeight * CGFloat(cols - 1), height: frameHeight / 2)
            .rotationEffect(Angle.degrees(60.3))
            .offset(x: cols % 2 == 0 ? xOffset - frameHeight/4 : xOffset)
            .foregroundColor(blue)
    }
    
    var xOffset: CGFloat {
        (CGFloat(cols / 2) * frameHeight / 2 - frameWidth/5 - CGFloat(cols / 2) * frameWidth)
    }
}
