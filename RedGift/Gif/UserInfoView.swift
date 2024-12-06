//
//  UserInfoView.swift
//  RedGift
//
//  Created by eliottwang on 2024/11/30.
//

import Kingfisher
import SwiftUI

struct UserInfoView: View {
  let profile: String?
  let isFollowed: Bool
  let toggleFollowed: () -> Void
  let timestamp: Int
  let user: String
  let isVerified: Bool
  let description: String
  @State var isCollapsed = true

  var body: some View {
    ZStack(alignment: .topLeading) {
      VStack(alignment: .leading, spacing: 8.uiScaled()) {
        HStack(spacing: 8.uiScaled()) {
          ZStack {
            Image("UserInfo/Profile").resizable()

            if let profile = profile { KFImage(URL(string: profile)).resizable() }
          }
          .scaledToFill().frame(width: 48.uiScaled(), height: 48.uiScaled()).clipShape(Circle())
          .shadow(color: .black, radius: 5.uiScaled(), x: 1.uiScaled(), y: 0.uiScaled())

          VStack(alignment: .leading, spacing: 0.uiScaled()) {
            Text(timestamp.prettyDate()).font(.custom("Poppins-Medium", size: 12.uiScaled()))
              .opacity(0.5).frame(height: 18.uiScaled())

            HStack(spacing: 4.uiScaled()) {
              Text(user).font(.custom("Poppins-Medium", size: 14.uiScaled()))
                .frame(height: 21.uiScaled())

              if isVerified { Image("UserInfo/Verified") }
            }
          }
        }

        let desc = description.trimmingCharacters(in: .whitespacesAndNewlines)
        if !desc.isEmpty {
          Text(desc).font(.custom("Poppins-Medium", size: 12.uiScaled())).opacity(0.6)
            .lineLimit(isCollapsed ? 1 : nil).onTapGesture { isCollapsed.toggle() }
        }
      }

      ZStack {
        LinearGradient(
          gradient: Gradient(colors: [Color("#8F2CF2"), Color("#CD4CFF")]), startPoint: .top,
          endPoint: .bottom)

        Image(isFollowed ? "UserInfo/Followed" : "UserInfo/Unfollowed").resizable()
          .frame(width: 9.uiScaled(), height: isFollowed ? 6.3.uiScaled() : 9.uiScaled())
      }
      .frame(width: 20.uiScaled(), height: 20.uiScaled()).clipShape(Circle())
      .padding(.top, 30.uiScaled()).onTapGesture { toggleFollowed() }
    }
    .frame(maxWidth: .infinity, alignment: .leading).padding(.leading, 16)
    .padding(.trailing, 16 + 34.uiScaled())
  }
}

#if DEBUG
  struct UserInfoView_Previews: PreviewProvider {
    static var previews: some View {
      ZStack {
        Color.red
        UserInfoView(
          profile: GifList.sample.gifs[0].urls.thumbnail, isFollowed: false, toggleFollowed: {},
          timestamp: 1_234_567_890, user: "Kuku", isVerified: true,
          description: "这是一段比较长的测试文本，用于测试SwiftUI中文本是否能够在一行内显示的动态调整。")
      }
    }
  }
#endif
