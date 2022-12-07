//
//  LoadableImage.swift
//  Emoji
//
//  Created by sun on 2022/11/1.
//

import SwiftUI

struct LoadableImage: View {
    var imageMetadata: Panda
    
    var body: some View {
        AsyncImage(url: imageMetadata.imageUrl) { phase in
            if let image = phase.image {
                image
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(15)
                    .shadow(radius: 5)
                    .accessibilityHidden(false)
                    .accessibilityValue(Text(imageMetadata.description))
            } else if phase.error != nil {
                VStack {
                    Image("pandaplaceholder")
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: 300)
                    Text("the panda were all busy")
                        .font(.title2)
                    Text("please try again")
                        .font(.title3)
                }
            } else {
                ProgressView()
            }
        }
        
    }
}
