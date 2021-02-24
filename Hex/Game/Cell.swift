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
            color = .gray
        case 1:
            color = .red
        case 2:
            color = .blue
        case 3:
            color = .white
        default:
            print("Unexpected color code")
            color = .gray
        }
    }
}
