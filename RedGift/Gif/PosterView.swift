//
//  PosterView.swift
//  RedGift
//
//  Created by eliottwang on 2024/11/29.
//

import SwiftUI

import Kingfisher

struct PosterView: View {
    var url: String

    var body: some View {
        GeometryReader { geometry in
            KFImage(URL(string: url))
                .resizable()
                .scaledToFit()
                .frame(width: geometry.size.width, height: geometry.size.height)
                .overlay {
                    ProgressView()
                        .colorInvert()
                        .scaleEffect(2)
                        .shadow(color: .black, radius: 5, x: 1, y: 0)
                }
        }
    }
}

#if DEBUG
struct PosterView_Previews: PreviewProvider {
    static var previews: some View {
        PosterView(url: GifList.sample.gifs[0].urls.thumbnail)
    }
}
#endif
