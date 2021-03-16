//
//  PolygonShape.swift
//  Hex
//
//  Created by Duong Pham on 2/14/21.
//

import SwiftUI

struct PolygonShape: Shape {
    var sides: Int
    
    func path(in rect: CGRect) -> Path {
        let h = Double(min(rect.size.width, rect.size.height)) / 2.0
        let c = CGPoint(x: rect.size.width / 2.0, y: rect.size.height / 2.0)
        var path = Path()
        
        for i in 0..<sides {
            let angle = (Double(i) * (360.0 / Double(sides))) * Double.pi / 180
            let pt = CGPoint(x: c.x + CGFloat(sin(angle) * h), y: c.y + CGFloat(cos(angle) * h))
            
            if i == 0 {
                path.move(to: pt)
            }
            else {
                path.addLine(to: pt)
            }
        }
        path.closeSubpath()
        return path
    }
}
