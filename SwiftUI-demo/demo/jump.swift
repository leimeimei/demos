//
//  jump.swift
//  demo
//
//  Created by sun on 2022/8/30.
//

import SwiftUI

struct jump: View {
    var body: some View {
        NavigationView {
            NavigationLink(destination: Text("hello world")) {
                Text("go to the detail")
                    .font(.system(size: 36))
            }
            .navigationBarTitle("index page")
            .accentColor(Color.orange)
        }
    }
}

struct jump_Previews: PreviewProvider {
    static var previews: some View {
        jump()
    }
}
