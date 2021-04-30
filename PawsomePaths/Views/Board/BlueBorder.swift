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
        let backgroundBlue = Color(red: 0.2, green: 0.2549, blue: 0.584314, opacity: 1)

        Rectangle()
            .frame(width: frameHeight * (CGFloat(cols) - 1), height: frameHeight / 2)
            .rotationEffect(Angle.degrees(60.3))
            .offset(x: cols % 2 == 0 ? xOffset - frameHeight/4 : xOffset)
            .foregroundColor(backgroundBlue)
    }
    
    var xOffset: CGFloat {
        (CGFloat(cols / 2) * frameHeight / 2 - frameWidth/5 - CGFloat(cols / 2) * frameWidth)
    }
}
