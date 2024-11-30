//
//  SideBarView.swift
//  RedGift
//
//  Created by eliottwang on 2024/11/29.
//

import SwiftUI

import ComposableArchitecture

struct SideBarView: View {
    let views: Int
    let likes: Int
    let isLiked: Bool
    let toggleLiked: () -> Void
    let isMuted: Bool
    let toggleMuted: () -> Void

    struct Item: View {
        let icon: String
        let label: String

        var body: some View {
            VStack(spacing: 5) {
                Image(icon)

                Text(label)
                    .font(.custom("Poppins-Regular", size: 12))
                    .frame(height: 18)
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
            VStack(spacing: 5) {
                Image(icons[currentState ? 1 : 0])
                    .onTapGesture {
                        onTapGuesture()
                    }

                Text(labels[currentState ? 1 : 0])
                    .font(.custom(Self.fonts[currentState ? 1 : 0], size: 12))
                    .frame(height: 18)
            }
        }
    }

    var body: some View {
        VStack(spacing: 13) {
            Item(icon: "SideBar/Views", label: views.prettyFormat())

            BiStateItem(
                Item(icon: "SideBar/Liked", label: (likes + 1).prettyFormat()),
                Item(icon: "SideBar/Unliked", label: likes.prettyFormat()),
                isLiked
            ) { toggleLiked() }

            BiStateItem(
                Item(icon: "SideBar/SoundOn", label: "On"),
                Item(icon: "SideBar/SoundOff", label: "Off"),
                isMuted
            ) { toggleMuted() }
        }
        .padding(16)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
        .shadow(color: .black, radius: 5, x: 1, y: 0)
    }
}

#if DEBUG
struct SideBarView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.red
            SideBarView(views: 6789, likes: 21, isLiked: false, toggleLiked: {}, isMuted: false, toggleMuted: {})
        }
    }
}
#endif
