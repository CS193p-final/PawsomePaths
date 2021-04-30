//
//  Int+Infinity.swift
//  Hex
//
//  Created by Duong Pham on 2/25/21.
//

import Foundation

extension Int {
    public static func add(_ left: Int, _ right: Int) -> Int {
        if left == Int.max || right == Int.max {
            return Int.max
        }
        return left + right
    }
}
