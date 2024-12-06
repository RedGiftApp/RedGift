//
//  GifFeature.swift
//  RedGift
//
//  Created by eliottwang on 2024/11/18.
//

import ComposableArchitecture
import Foundation

@Reducer struct GifFeature {
  @ObservableState struct State: Equatable, Identifiable {
    var id: UUID
    let gif: GifList.Gif
    let user: GifList.User
    let niches: [GifList.Niche]
    let tags: [String]

    var playerState: PlayerFeature.State

    var showPauseAnimation = false

    init(
      id: UUID, gif: GifList.Gif, user: GifList.User, niches: [GifList.Niche], tags: [String],
      pageIndex: Int
    ) {
      self.id = id
      self.gif = gif
      self.user = user
      self.niches = niches
      self.tags = tags
      playerState = PlayerFeature.State(urls: gif.urls, pageIndex: pageIndex)
    }
  }

  enum Action: Equatable { case playerAction(PlayerFeature.Action) }

  var body: some ReducerOf<GifFeature> {
    Scope(state: \.playerState, action: \.playerAction) { PlayerFeature() }

    Reduce { _, action in
      switch action {
      case .playerAction: return .none
      }
    }
  }
}
