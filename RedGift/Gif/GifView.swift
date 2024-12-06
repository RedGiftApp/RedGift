//
//  GifView.swift
//  RedGift
//
//  Created by eliottwang on 2024/11/18.
//

import ComposableArchitecture
import SwiftUI

struct GifView: View {
  let store: StoreOf<GifFeature>
  let tagListWidth: CGFloat

  init(store: StoreOf<GifFeature>) {
    self.store = store
    self.tagListWidth = Self.getTagListWidth(niches: store.niches, tags: store.tags)
  }

  var body: some View {
    ZStack {
      // Backdrop
      BackdropView(url: store.playerState.urls.thumbnail)

      // Player-Poster
      PosterView(url: store.playerState.urls.thumbnail)

      // Player-Video
      PlayerView(store: store.scope(state: \.playerState, action: \.playerAction))

      /// ** keep this **
      if store.playerState.isBuffering {
        ProgressView().scaleEffect(2).shadow(color: .black, radius: 5, x: 1, y: 0)
      }

      // Player-PlayButton
      PlayButtonView(doShow: store.playerState.isPaused)

      // ProgressBar
      ProgressBar(
        bufferTime: store.playerState.bufferTime, currentTime: store.playerState.currentTime,
        totalDuration: store.gif.duration
      ) { store.send(.playerAction(.seek($0))) }

      // MetaInfo
      MetaInfoView(
        gif: store.gif, user: store.user, niches: store.niches, tags: store.tags,
        toggleFollowed: { store.send(.playerAction(.toggleMuted)) },
        enableScrollForTagList: tagListWidth > UIScreen.main.bounds.width)

      // SideBar
      SideBarView(
        views: store.gif.views, likes: store.gif.likes, isLiked: FeedsFeature.isMuted,
        toggleLiked: { store.send(.playerAction(.toggleMuted)) }, isMuted: FeedsFeature.isMuted,
        toggleMuted: { store.send(.playerAction(.toggleMuted)) },
        saveSpaceForTagList: tagListWidth > UIScreen.main.bounds.width - 50)
    }
    .onTapGesture { store.send(.playerAction(.togglePause)) }
  }

  private static func getTagListWidth(niches: [GifList.Niche], tags: [String]) -> CGFloat {
    func getTextWidth(text: String) -> CGFloat {
      return NSString(string: text)
        .size(withAttributes: [
          NSAttributedString.Key.font: UIFont(name: "Poppins-Medium", size: 12)!
        ])
        .width
    }

    func widthWithThumbnail(text: String) -> CGFloat {
      let border: CGFloat = 1
      let padding: CGFloat = 6
      let thumbnailWidth: CGFloat = 24
      let textWidth = getTextWidth(text: text)
      return border + padding + thumbnailWidth + padding + textWidth + padding + border
    }

    func widthWithoutThumbnail(text: String) -> CGFloat {
      let border: CGFloat = 1
      let padding: CGFloat = 12
      let textWidth = getTextWidth(text: text)
      return border + padding + textWidth + padding + border
    }

    let padding: CGFloat = 16
    let nichesWidth =
      niches.map {
        $0.thumbnail == nil
          ? widthWithoutThumbnail(text: $0.name) : widthWithThumbnail(text: $0.name)
      }
      .reduce(into: 0, { $0 += $1 })
    let tagsWidth = tags.map { widthWithoutThumbnail(text: $0) }.reduce(into: 0, { $0 += $1 })
    let spacing = max(0, CGFloat(niches.count + tags.count - 1)) * 8
    return padding + nichesWidth + tagsWidth + spacing + padding
  }
}

#if DEBUG
  struct GifView_Previews: PreviewProvider {
    static var previews: some View {
      GifView(
        store: Store(
          initialState: GifFeature.State(
            id: UUID(), gif: GifList.sample.gifs[0], user: GifList.sample.users[0],
            niches: GifList.sample.niches, tags: GifList.sample.tags, pageIndex: 0),
          reducer: { GifFeature() }))
    }
  }
#endif
