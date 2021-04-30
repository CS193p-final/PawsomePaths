//
//  SparkTrajectory.swift
//  Hex
//
//  Created by Giang Nguyenn on 2/24/21.
//  Credit to: Tomasz Szulc
//  http://szulctomasz.com/programming-blog/2018/09/add-fireworks-and-sparks-to-a-uiview/

import Foundation
import SwiftUI
import UIKit

protocol SparkTrajectory {
    // Stores all points that define a trajectory
    var points: [CGPoint] {
        get
        set
    }
    // A path representing trajectory
    var path: UIBezierPath { get}
}

extension SparkTrajectory {
    //Scales a trajectory so it fits to a UI requirements in term of size of a trajectory
    // Use it after all other transforms have been applied and therefore 'shift'
    func scale(by value: CGFloat) -> SparkTrajectory {
        var copy = self
        (0..<self.points.count).forEach {
            copy.points[$0].multiply(by: value)
        }
        return copy
    }
    
    // Flips trajectory horizontally
    func flip() -> SparkTrajectory {
        var copy = self
        (0..<self.points.count).forEach {copy.points[$0].x *= -1
        }
        return copy
    }
    
    // Shifts a trajectory by (x, y). Applies to each point.
    // Use it after all other transformation have been applied and after 'scale'.
    func shift(to point: CGPoint) -> SparkTrajectory {
        var copy = self
        let vector = CGVector(dx: point.x, dy: point.y)
        (0..<self.points.count).forEach {
            copy.points[$0].add(vector: vector)
        }
        return copy
    }
}

struct CubicBezierTrajectory: SparkTrajectory {
    var points = [CGPoint]()
    
    init(_ x0: CGFloat, _ y0: CGFloat,
         _ x1: CGFloat, _ y1: CGFloat,
         _ x2: CGFloat, _ y2: CGFloat,
         _ x3: CGFloat, _ y3: CGFloat) {
        self.points.append(CGPoint(x: x0, y: y0))
        self.points.append(CGPoint(x: x1, y: y1))
        self.points.append(CGPoint(x: x2, y: y2))
        self.points.append(CGPoint(x: x3, y: y3))
    }
    
    var path: UIBezierPath {
        guard self.points.count == 4 else {
            fatalError("4 points required")
        }
        let path = UIBezierPath()
        path.move(to: self.points[0])
        path.addCurve(to: self.points[3], controlPoint1: self.points[1], controlPoint2: self.points[2])
        return path
    }
}

protocol SparkTrajectoryFactory{}

protocol ClassicSparkTrajectoryFactoryProtocol: SparkTrajectoryFactory {
    func randomTopRight() -> SparkTrajectory
    func randomBottomRight() -> SparkTrajectory
}

final class ClassicSparkTrajectoryFactory: ClassicSparkTrajectoryFactoryProtocol {
    private lazy var topRight: [SparkTrajectory] = {
        [CubicBezierTrajectory(0.00, 0.00, 0.31, -0.46, 0.74, -0.29, 0.99, 0.12),
         CubicBezierTrajectory(0.00, 0.00, 0.31, -0.46, 0.62, -0.49, 0.88, -0.19),
         CubicBezierTrajectory(0.00, 0.00, 0.10, -0.54, 0.44, -0.53, 0.66, -0.30),
         CubicBezierTrajectory(0.00, 0.00, 0.19, -0.46, 0.41, -0.53, 0.65, -0.45)]
    }()
    
    private lazy var bottomRight: [SparkTrajectory] = {
        [CubicBezierTrajectory(0.00, 0.00, 0.42, -0.01, 0.68, 0.11, 0.87, 0.44),
         CubicBezierTrajectory(0.00, 0.00, 0.35, 0.00, 0.55, 0.12, 0.62, 0.45),
         CubicBezierTrajectory(0.00, 0.00, 0.21, 0.05, 0.31, 0.19, 0.32, 0.45),
         CubicBezierTrajectory(0.00, 0.00, 0.18, 0.00, 0.31, 0.11, 0.35, 0.25)]
    }()
    
    func randomTopRight() -> SparkTrajectory {
        return self.topRight[Int(arc4random_uniform(UInt32(self.topRight.count)))]
    }
    
    func randomBottomRight() -> SparkTrajectory {
        return self.bottomRight[Int(arc4random_uniform(UInt32(self.bottomRight.count)))]

    }
}
