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
    
    init(id: Int, colorCode: Int = 0) {
        self.id = id
        switch colorCode {
        case 0:
            color = .purple
        case 1:
            color = .red
        case 2:
            color = .blue
        default:
            print("Unexpected color code")
            color = .purple
        }
    }
    
    mutating func changeColor() {
        if color == Color.red {
            color = .blue
        } else {
            color = .red
        }
    }
}
