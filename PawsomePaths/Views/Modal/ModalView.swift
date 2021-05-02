import SwiftUI

struct ModalView: View {
    // Modal State
    @Binding var modal: Modal
    @GestureState var dragState: DragState = .inactive
    
    var animation: Animation {
        Animation
            .interpolatingSpring(stiffness: 300.0, damping: 30.0, initialVelocity: 10.0)
            .delay(0)
    }
    
    var body: some View {
        return GeometryReader(){ geometry in
            ZStack(alignment: .top) {
                Color.black
                    .opacity(self.modal.position != .closed ? 0.5 : 0)
                    .onTapGesture {
                        self.modal.position = .closed
                    }
            }
            ZStack(alignment: .top) {
                Color.wildBlueYonder
                self.modal.content
            }
            .mask(RoundedRectangle(cornerRadius: 8, style: .continuous))
            .offset(y: max(0, self.modal.position.offsetFromTop() + self.dragState.translation.height + geometry.safeAreaInsets.top))
            .animation(self.dragState.isDragging ? nil : self.animation)
        }
        .edgesIgnoringSafeArea(.top)
    }
}

enum DragState {
    
    case inactive
    case dragging(translation: CGSize)
    
    var translation: CGSize {
        switch self {
        case .inactive:
            return .zero
        case .dragging(let translation):
            return translation
        }
    }
    
    var isDragging: Bool {
        switch self {
        case .inactive:
            return false
        case .dragging:
            return true
        }
    }
}
