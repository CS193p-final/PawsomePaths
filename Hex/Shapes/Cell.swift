//
//  Cell.swift
//  Hex
//
//  Created by Giang Nguyenn on 2/14/21.
//

import Foundation
import SwiftUI

class Cell: Identifiable, ObservableObject {
    var id: Int
    @Published var color: Color
    
    init(id: Int) {
        self.id = id
        color = .white
    }
    
    func changeColor() {
        if color == Color.red {
            color = .blue
        } else {
            color = .red
        }
    }
}
