//
//  GifView.swift
//  RedGift
//
//  Created by eliottwang on 2024/11/18.
//

import SwiftUI

import ComposableArchitecture

struct GifView: View {
    let store: StoreOf<GifFeature>

    var body: some View {
        ZStack {
            // Backdrop
            BackdropView(url: store.playerState.urls.thumbnail)

            // Player-Poster
            PosterView(url: store.playerState.urls.thumbnail)

            // Player-Video
            PlayerView(store: store.scope(state: \.playerState, action: \.playerAction))

            // Player-PlayButton
            PlayButtonView(doShow: store.playerState.isPaused)

            // ProgressBar
            ProgressBar(
                bufferTime: store.playerState.bufferTime,
                currentTime: store.playerState.currentTime,
                totalDuration: store.gif.duration
            ) { store.send(.playerAction(.seek($0))) }

            // MetaInfo
            ZStack {
                let userName = store.user.name ?? ""
                let user = !userName.isEmpty ? userName : store.user.username
                let gifDesc = store.gif.description ?? ""
                let userDesc = store.user.description ?? ""
                let desc = !gifDesc.isEmpty ? gifDesc : userDesc
                UserInfoView(
                    profile: store.user.profileImageUrl,
                    isFollowed: !FeedsFeature.isMuted,
                    toggleFollowed: { store.send(.playerAction(.toggleMuted)) },
                    timestamp: store.gif.createDate,
                    user: user,
                    isVerified: store.user.verified,
                    description: desc
                )
            }
            .frame(maxHeight: .infinity, alignment: .bottom)

            // SideBar
            SideBarView(
                views: store.gif.views,
                likes: store.gif.likes,
                isLiked: FeedsFeature.isMuted,
                toggleLiked: { store.send(.playerAction(.toggleMuted)) },
                isMuted: FeedsFeature.isMuted,
                toggleMuted: { store.send(.playerAction(.toggleMuted)) }
            )
        }
        .onTapGesture {
            store.send(.playerAction(.togglePause))
        }
    }
}

#if DEBUG
struct GifView_Previews: PreviewProvider {
    static var previews: some View {
        GifView(
            store: Store(
                initialState: GifFeature.State(
                    id: UUID(),
                    gif: GifList.sample.gifs[0],
                    user: GifList.sample.users[0],
                    pageIndex: 0
                ),
                reducer: { GifFeature() }
            )
        )
    }
}
#endif
