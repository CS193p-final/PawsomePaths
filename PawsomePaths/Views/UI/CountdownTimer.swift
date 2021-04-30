//
//  CountdownTimer.swift
//  Hex
//
//  Created by Duong Pham on 3/18/21.
//

import SwiftUI

struct CountdownTimer: View {
    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    var duration: CGFloat
    
    @State var isActive = false
    @State private var timeRemaining: CGFloat
    
    init(amount: CGFloat) {
        duration = amount
        _timeRemaining = State(wrappedValue: duration)
    }
    
    var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width
            let _ = geometry.size.height
            ZStack(alignment: .leading) {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .clipShape(Capsule())
                Rectangle()
                    .fill(Color.green)
                    .frame(width: width * percentTimeRemaining)
                    .clipShape(Capsule())
                    .animation(.linear)
            }
                .frame(height: 20)
        }
        .onReceive(timer, perform: { _ in
            print("hello")
            if timeRemaining > 0 {
                timeRemaining -= 0.1
            }
        })
    }
    
    var percentTimeRemaining: CGFloat {
        timeRemaining / duration
    }
}

struct CountdownTimer_Previews: PreviewProvider {
    static var previews: some View {
        CountdownTimer(amount: 10)
    }
}
