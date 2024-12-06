//
//  TagListView.swift
//  RedGift
//
//  Created by eliottwang on 2024/12/7.
//

import Kingfisher
import SwiftUI

struct TagListView: View {
  let niches: [GifList.Niche]
  let tags: [String]
  let enableScroll: Bool

  struct TagButton: View {
    var title: String
    var thumbnailUrl: String? = nil
    var borderColor = Color("#FF536D")

    var body: some View {
      HStack(spacing: 6) {
        if let thumbnailUrl = thumbnailUrl {
          KFImage(URL(string: thumbnailUrl)).resizable().scaledToFill().frame(width: 24, height: 24)
            .clipShape(Circle())
        }

        Text(title).font(.custom("Poppins-Medium", size: 12)).frame(height: 18)
          .shadow(color: .black, radius: 5, x: 1, y: 0)
      }
      .frame(height: 35).padding(.horizontal, thumbnailUrl == nil ? 12.5 : 6.5)
      .overlay(RoundedRectangle(cornerRadius: 24).stroke(borderColor, lineWidth: 1)).padding(0.5)
    }
  }

  var body: some View {
    VStack(spacing: 8) {
      if enableScroll {
        ScrollView(.horizontal, showsIndicators: false) { generateTags() }
      } else {
        generateTags()
      }
    }
  }

  func generateTags() -> some View {
    return LazyHStack(spacing: 8) {
      ForEach(niches, id: \.id) { niche in
        TagButton(title: niche.name, thumbnailUrl: niche.thumbnail, borderColor: .white)
      }
      ForEach(tags, id: \.self) { tag in TagButton(title: tag) }
    }
    .frame(height: 36).frame(maxWidth: .infinity, alignment: .leading).padding(.horizontal, 16)
  }
}

#if DEBUG
  struct TagListView_Previews: PreviewProvider {
    static var previews: some View {
      ZStack {
        Color.red
        TagListView(niches: GifList.sample.niches, tags: GifList.sample.tags, enableScroll: true)
      }
    }
  }
#endif
