//
//  GifFeature.swift
//  RedGift
//
//  Created by eliottwang on 2024/11/18.
//

import Foundation

import ComposableArchitecture

@Reducer
struct GifFeature {
    @ObservableState
    struct State: Equatable, Identifiable {
        var id: UUID
        let gif: GifList.Gif
        let user: GifList.User

        var playerState: PlayerFeature.State

        var showPauseAnimation = false

        init(id: UUID, gif: GifList.Gif, user: GifList.User, pageIndex: Int) {
            self.id = id
            self.gif = gif
            self.user = user
            playerState = PlayerFeature.State(urls: gif.urls, pageIndex: pageIndex)
        }
    }

    enum Action: Equatable {
        case playerAction(PlayerFeature.Action)
    }

    var body: some ReducerOf<GifFeature> {
        Scope(state: \.playerState, action: \.playerAction) {
            PlayerFeature()
        }
        Reduce { _, action in
            switch action {
            case .playerAction:
                return .none
            }
        }
    }
}
