//
//  FireworkView.swift
//  Hex
//
//  Created by Giang Nguyenn on 2/25/21.
//

import Foundation
import SwiftUI

struct FireworkRepresentable: UIViewRepresentable {
    let fireworkController = ClassicFireworkController()
    let label = UIButton()
    func makeUIView(context: Context) -> some UIView {
        label.setTitle("🎉🎉🎉", for: .normal)
        label.style()
        return label
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        fireworkController.addFireworks(sparks: 2, around: label)
    }
}

final class FireworkView: UIViewController {
    let fireworkController = ClassicFireworkController()
}

extension UIButton {

    func style() {
        let color = UIColor(red:0.42, green:0.58, blue:0.98, alpha:1.00)
        self.backgroundColor = color
        self.setTitleColor(.white, for: .normal)
        self.layer.cornerRadius = 8
        self.titleLabel!.font = UIFont.boldSystemFont(ofSize: 20)

        let layer = self.layer
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 10)
        layer.shadowRadius = 6.0
        layer.shadowOpacity = 0.3

        let shadowWidth = layer.bounds.width * 0.9
        let shadowRect = CGRect(x: 0 + (layer.bounds.width - shadowWidth) / 2.0, y: 0, width: shadowWidth, height: layer.bounds.height)
        layer.shadowPath = UIBezierPath(rect: shadowRect).cgPath

        layer.zPosition = 2
    }
}
