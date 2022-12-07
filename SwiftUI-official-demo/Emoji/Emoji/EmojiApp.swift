//
//  EmojiApp.swift
//  Emoji
//
//  Created by sun on 2022/11/1.
//

import SwiftUI

@main
struct EmojiApp: App {
    @StateObject private var fetcher = PandaCollectionFetcher()
    var body: some Scene {
        WindowGroup {
            NavigationView {
                MemeCreator()
                    .environmentObject(fetcher)
            }
        }
    }
}
