//
//  BackdropView.swift
//  RedGift
//
//  Created by eliottwang on 2024/11/29.
//

import Kingfisher
import SwiftUI

struct BackdropView: View {
  var url: String

  var body: some View {
    GeometryReader { geometry in
      ZStack {
        KFImage(URL(string: url)).resizable().scaledToFill()
          .frame(width: geometry.size.width, height: geometry.size.height).blur(radius: 18)
          .opacity(0.5).clipped()
      }
    }
    .ignoresSafeArea(edges: .top)
    .overlay {
      GeometryReader { geometry in
        ZStack {
          LinearGradient(
            gradient: Gradient(stops: [
              .init(color: .black, location: 0.0),
              .init(color: .clear, location: 10 / geometry.safeAreaInsets.top),
            ]), startPoint: .top, endPoint: .bottom
          )
          .frame(height: geometry.safeAreaInsets.top)
        }
        .frame(maxHeight: .infinity, alignment: .top).ignoresSafeArea()
      }
    }
  }
}

struct BackdropView_Previews: PreviewProvider {
  static var previews: some View { BackdropView(url: GifList.sample.gifs[0].urls.thumbnail) }
}
