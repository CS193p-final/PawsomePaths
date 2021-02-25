//
//  SparkView.swift
//  Hex
//
//  Created by Giang Nguyenn on 2/24/21.
//

import Foundation
import SwiftUI

class SparkView: UIView {}

final class CircleColorSparkView: SparkView {
    init(color: UIColor, size: CGSize) {
        super.init(frame: CGRect(origin: .zero, size: size))
        self.backgroundColor = color
        self.layer.cornerRadius = self.frame.width / 2.0
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

extension UIColor {
    static var sparkColorSet1: [UIColor] = {
        return [UIColor(red: 0.89,green: 0.58, blue: 0.70, alpha: 1.00),
                UIColor(red: 0.96,green: 0.87, blue: 0.62, alpha: 1.00),
                UIColor(red: 0.67,green: 0.82, blue: 0.94, alpha: 1.00),
                UIColor(red: 0.54,green: 0.56, blue: 0.94, alpha: 1.00)]
    }()
}

protocol SparkViewFactoryData {
    var size: CGSize { get }
    var index: Int { get }
}

protocol SparkViewFactory {
    func create(with data: SparkViewFactoryData) -> SparkView
}

public struct DefaultSparkViewFactoryData: SparkViewFactoryData {
    public let size: CGSize
    public let index: Int
}

class CircleColorSparkViewFactory: SparkViewFactory {
    var colors: [UIColor] {
        return UIColor.sparkColorSet1
    }
    
    func create(with data: SparkViewFactoryData) -> SparkView {
        let color = self.colors[data.index % self.colors.count]
        return CircleColorSparkView(color: color, size: data.size)
    }
}
