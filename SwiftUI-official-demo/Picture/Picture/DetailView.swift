//
//  DetailView.swift
//  Picture
//
//  Created by sun on 2022/10/31.
//

import SwiftUI

struct DetailView: View {
    
    let item: Item
    
    var body: some View {
        AsyncImage(url: item.url) { image in
            image
                .resizable()
                .scaledToFit()
        } placeholder: {
            ProgressView()
        }
    }
}
