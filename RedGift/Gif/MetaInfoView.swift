//
//  MetaInfoView.swift
//  RedGift
//
//  Created by eliottwang on 2024/12/7.
//

import Kingfisher
import SwiftUI

struct MetaInfoView: View {
  let gif: GifList.Gif
  let user: GifList.User
  let niches: [GifList.Niche]
  let tags: [String]
  let toggleFollowed: () -> Void
  let enableScrollForTagList: Bool

  var body: some View {
    VStack(spacing: 8.uiScaled()) {
      let userName = user.name ?? ""
      let userNameOrId = !userName.isEmpty ? userName : user.username
      let gifDesc = gif.description ?? ""
      let userDesc = user.description ?? ""
      let desc = !gifDesc.isEmpty ? gifDesc : userDesc
      UserInfoView(
        profile: user.profileImageUrl, isFollowed: !FeedsFeature.isMuted,
        toggleFollowed: toggleFollowed, timestamp: gif.createDate, user: userNameOrId,
        isVerified: user.verified, description: desc)
      TagListView(niches: niches, tags: tags, enableScroll: enableScrollForTagList)
    }
    .padding(.top, 16.uiScaled()).padding(.bottom, 16)
    .background {
      LinearGradient(
        gradient: Gradient(stops: [
          .init(color: .black, location: 0), .init(color: .black.opacity(0.498), location: 0.2),
          .init(color: .black.opacity(0.3), location: 0.77), .init(color: .clear, location: 1.0),
        ]), startPoint: .bottom, endPoint: .top
      )
      .ignoresSafeArea()
    }
    .frame(maxHeight: .infinity, alignment: .bottom)
  }
}

struct MetaInfoView_Previews: PreviewProvider {
  static var previews: some View {
    ZStack {
      Color.red.ignoresSafeArea()
      MetaInfoView(
        gif: GifList.sample.gifs[0], user: GifList.sample.users[0], niches: GifList.sample.niches,
        tags: GifList.sample.tags, toggleFollowed: {}, enableScrollForTagList: true)
    }
  }
}
