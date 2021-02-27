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
    let label = UILabel()
    var text: String
    func makeUIView(context: Context) -> some UIView {
        label.text = "\(text)"
        label.style()
        return label
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        fireworkController.addFireworks(sparks: 8, around: label)
    }
}


extension UILabel {

    func style() {

        self.textColor = .white
        self.layer.cornerRadius = 8
        self.font = UIFont.boldSystemFont(ofSize: 20)

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
