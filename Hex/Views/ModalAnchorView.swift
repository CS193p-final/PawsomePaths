//
//  ModalAnchorView.swift
//  Hex
//
//  Created by Giang Nguyenn on 3/21/21.
//

import SwiftUI

struct ModalAnchorView: View {
    @EnvironmentObject var modalManager: ModalManager
    
    var body: some View {
        ModalView(modal: $modalManager.modal)
    }
}
