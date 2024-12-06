//
//  SideBarView.swift
//  RedGift
//
//  Created by eliottwang on 2024/11/29.
//

import ComposableArchitecture
import SwiftUI

struct SideBarView: View {
  let views: Int
  let likes: Int
  let isLiked: Bool
  let toggleLiked: () -> Void
  let isMuted: Bool
  let toggleMuted: () -> Void
  let saveSpaceForTagList: Bool

  struct Item: View {
    let icon: String
    let label: String

    var body: some View {
      VStack(spacing: 5.uiScaled()) {
        Image(icon).scaleEffect(1.uiScaled())

        Text(label).font(.custom("Poppins-Regular", size: 12.uiScaled()))
              .frame(width: 24.uiScaled(), height: 18.uiScaled())
      }
    }
  }

  struct BiStateItem: View {
    let icons: [String]
    let labels: [String]
    static let fonts = ["Poppins-Regular", "Poppins-Medium"]
    let currentState: Bool
    let onTapGuesture: () -> Void

    init(_ state0: Item, _ state1: Item, _ state: Bool, onTap: @escaping () -> Void) {
      icons = [state0.icon, state1.icon]
      labels = [state0.label, state1.label]
      currentState = state
      onTapGuesture = onTap
    }

    var body: some View {
      VStack(spacing: 5.uiScaled()) {
        Image(icons[currentState ? 1 : 0]).scaleEffect(1.uiScaled())
          .onTapGesture { onTapGuesture() }

        Text(labels[currentState ? 1 : 0])
          .font(.custom(Self.fonts[currentState ? 1 : 0], size: 12.uiScaled()))
          .frame(width: 24.uiScaled(), height: 18.uiScaled())
      }
    }
  }

  var body: some View {
    VStack(spacing: 13.uiScaled()) {
      Item(icon: "SideBar/Views", label: views.prettyFormat())

      BiStateItem(
        Item(icon: "SideBar/Liked", label: (likes + 1).prettyFormat()),
        Item(icon: "SideBar/Unliked", label: likes.prettyFormat()), isLiked
      ) { toggleLiked() }

      BiStateItem(
        Item(icon: "SideBar/SoundOn", label: "On"), Item(icon: "SideBar/SoundOff", label: "Off"),
        isMuted
      ) { toggleMuted() }
    }
    .padding(.trailing, 16).padding(.bottom, saveSpaceForTagList ? 16 + 44.uiScaled() : 16)
    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
    .shadow(color: .black, radius: 5.uiScaled(), x: 1.uiScaled(), y: 0.uiScaled())
  }
}

#if DEBUG
  struct SideBarView_Previews: PreviewProvider {
    static var previews: some View {
      ZStack {
        Color.red
        SideBarView(
          views: 6789, likes: 21, isLiked: false, toggleLiked: {}, isMuted: false, toggleMuted: {},
          saveSpaceForTagList: false)
      }
    }
  }
#endif
