//
//  CGPoint+Extensions.swift
//  Hex
//
//  Created by Giang Nguyenn on 2/25/21.
//

import Foundation
import SwiftUI

extension CGPoint {
    mutating func add(vector: CGVector) {
        self.x += vector.dx
        self.y += vector.dy
    }
    
    mutating func adding(vector: CGVector) -> CGPoint {
        var copy = self
        copy.add(vector: vector)
        return copy
    }
    
    mutating func multiply(by const: CGFloat) {
        self.x *= const
        self.y *= const
    }
}
