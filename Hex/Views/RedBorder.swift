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
        let backgroundRed = Color(red: 0.929512, green: 0.1407, blue: 0.307, opacity: 1)
        Rectangle()
            .frame(width: frameWidth * (CGFloat(cols) - 0.5), height: frameHeight / 2, alignment: .leading).foregroundColor(backgroundRed)
    }
}

