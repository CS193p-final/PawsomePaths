//
//  Cell.swift
//  Hex
//
//  Created by Giang Nguyenn on 2/14/21.
//

import Foundation
import SwiftUI

struct Cell: Identifiable {
    var id: Int
    var color: Color
    let blue = Color(red:0.39, green:0.55, blue:0.894)
    let red = Color(red: 0.9296875, green: 0.46, blue: 0.453)
    let gray = Color(red: 0.6289, green: 0.6328, blue: 0.64453)


    init(id: Int, colorCode: Int = 0) {
        self.id = id
        switch colorCode {
        case 0:
            color = gray
        case 1:
            color = red
        case 2:
            color = blue
        case 3:
            color = .white
        default:
            print("Unexpected color code: \(colorCode)")
            color = gray
        }
    }
}
