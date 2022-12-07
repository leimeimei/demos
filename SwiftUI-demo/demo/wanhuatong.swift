//
//  wanhuatong.swift
//  demo
//
//  Created by sun on 2022/8/30.
//

import SwiftUI

struct NewCapsule: View {
    var color: Color
    var degree: Double
    var body: some View {
        Capsule()
            .foregroundColor(color)
            .frame(width: 60, height: 90)
            .offset(x: 0, y: 60)
            .opacity(0.75)
            .rotationEffect(.degrees(degree))
    }
}

struct CircleCapsule: View {
    var body: some View {
        ZStack {
            NewCapsule(color: .red, degree: 0)
            NewCapsule(color: .red, degree: 45)
            NewCapsule(color: .yellow, degree: 90)
            NewCapsule(color: .yellow, degree: 135)
            NewCapsule(color: .blue, degree: 180)
            NewCapsule(color: .blue, degree: 225)
            NewCapsule(color: .green, degree: 270)
            NewCapsule(color: .green, degree: 315)
        }
    }
}

struct wanhuatong: View {
    @State private var rotate = false
    @State private var scale = false
    
    @State private var rotate1 = false
    @State private var scale1 = false
    var body: some View {
        let ani: Animation = .easeInOut(duration: 4)
            .repeatForever()
        VStack {
            Spacer()
            CircleCapsule()
                .rotationEffect(.degrees(rotate ? 0 : 360), anchor: .center)
                .scaleEffect(scale ? 0.2 : 1)
                .animation(ani)
                .onTapGesture {
                    self.rotate.toggle()
                    self.scale.toggle()
                }
            Spacer()
//            Divider()
//                .frame(height: 100)
            
            CircleCapsule()
                .rotationEffect(.degrees(rotate1 ? 0 : 360), anchor: .center)
                .scaleEffect(scale1 ? 0.2 : 1)
                .onTapGesture {
                    withAnimation(.easeInOut(duration: 2)) {
                        self.rotate1.toggle()
                        self.scale1.toggle()
                    }
                }
            Spacer()
        }.padding()
    }
}
// 万花筒
struct wanhuatong_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            wanhuatong()
        }
    }
}
