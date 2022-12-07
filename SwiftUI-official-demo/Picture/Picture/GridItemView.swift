//
//  GridItemView.swift
//  Picture
//
//  Created by sun on 2022/10/31.
//

import SwiftUI

struct GridItemView: View {
    let size: Double
    let item: Item
    
    var body: some View {
        ZStack(alignment:.topTrailing) {
            AsyncImage(url: item.url) { image in
                image.resizable().scaledToFit()
            } placeholder: {
                ProgressView()
            }

        }
        .frame(width: size, height: size)
    }
}
