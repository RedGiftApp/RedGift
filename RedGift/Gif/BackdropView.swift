//
//  BackdropView.swift
//  RedGift
//
//  Created by eliottwang on 2024/11/29.
//

import SwiftUI

import Kingfisher

struct BackdropView: View {
    var url: String

    var body: some View {
        GeometryReader { geometry in
            KFImage(URL(string: url))
                .resizable()
                .scaledToFill()
                .frame(width: geometry.size.width, height: geometry.size.height)
                .blur(radius: 18)
                .opacity(0.5)
        }
        .clipped()
    }
}

#if DEBUG
struct BackdropView_Previews: PreviewProvider {
    static var previews: some View {
        BackdropView(url: GifList.sample.gifs[0].urls.thumbnail)
    }
}
#endif
