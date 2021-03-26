//
//  ModalState.swift
//  Hex
//
//  Created by Giang Nguyenn on 3/21/21.
//

import SwiftUI

enum ModalState: CGFloat {
    case closed, partiallyRevealed, open
    func offsetFromTop() -> CGFloat {
        switch self {
        case .closed:
            return UIScreen.main.bounds.height
        case .partiallyRevealed:
            return UIScreen.main.bounds.height - 200
        case .open:
            return UIScreen.main.bounds.height / 2
        }
    }
}

struct Modal {
    var position: ModalState = .closed
    var dragOffset: CGSize = .zero
    var content: AnyView?
}
