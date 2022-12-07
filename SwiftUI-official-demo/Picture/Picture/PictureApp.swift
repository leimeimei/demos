//
//  PictureApp.swift
//  Picture
//
//  Created by sun on 2022/10/31.
//

import SwiftUI

@main
struct PictureApp: App {
    @StateObject var dataModel = DataModel()
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                GridView()
            }
            .environmentObject(dataModel)
            .navigationViewStyle(.stack)
        }
    }
}
