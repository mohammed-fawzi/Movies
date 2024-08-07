//
//  CachableImage.swift
//  
//
//  Created by Mohamed Fawzy on 07/08/2024.
//

import SwiftUI

struct CachableImage: View {
     var url: String
    @State var image: Image = Image(.posterPlaceholderSm)
    init(url: String) {
        self.url = url
    }
    var body: some View {
        image
            .resizable()
            .onAppear{
                ImageLoader.shared.loadImage(from: url) { image in
                    self.image = Image(uiImage: image!)
                }
            }
            .onChange(of: url) { _, _ in
                ImageLoader.shared.loadImage(from: url) { image in
                    self.image = Image(uiImage: image!)
                }
            }
            
    }
}
