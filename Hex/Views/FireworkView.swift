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
    func makeUIView(context: Context) -> some UIView {
        label.text = "🎉🎉🎉"
        return label
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        fireworkController.addFireworks(sparks: 2, around: UILabel())
    }
}
