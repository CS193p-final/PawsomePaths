//
//  ModalManager.swift
//  Hex
//
//  Created by Giang Nguyenn on 3/21/21.
//

import SwiftUI

class ModalManager: ObservableObject {
    @Published var modal: Modal = Modal(position: .closed, content: nil)
    
    func newModal<Content: View>(position: ModalState, @ViewBuilder content: () -> Content) {
        modal = Modal(position: position, content: AnyView(content()))
    }
    
    func openModal() {
        modal.position = .partiallyRevealed
    }
    
    func closeModal() {
        modal.position = .closed
    }
}
