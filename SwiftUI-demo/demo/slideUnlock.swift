//
//  ContentView.swift
//  demo
//
//  Created by sun on 2022/8/30.
//

import SwiftUI

struct slideUnlock: View {
    
    @State var shift = false
    
    var body: some View {
        ZStack {
            Text("slide to unlock")
                .font(.largeTitle)
                .foregroundColor(.purple)
                .brightness(-0.2)
                .hueRotation(.degrees(shift ? 0 : 720))
                .animation(.easeInOut(duration: 4))
                .onTapGesture {
                    self.shift = true
                }
            Rectangle()
                .frame(width: 220, height: 40)
                .foregroundColor(.white)
                .opacity(0.5)
                .rotationEffect(.degrees(0), anchor: .trailing)
                .scaleEffect(x: shift ? 0 : 1, y: 1, anchor: .trailing)
                .animation(.easeInOut(duration: 4))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        slideUnlock()
    }
}
