//
//  FeedsFeature.swift
//  RedGift
//
//  Created by eliottwang on 2024/11/18.
//

import ComposableArchitecture
import Foundation
import Logging

private let logger = Logger(label: "ren.hazuki.RedGift.Feeds.FeedsFeature")

@Reducer struct FeedsFeature {
  static var currentPageIndex = 0
  static var isMuted = RedGiftApp.settingsStore.muteOnStartUp

  enum FetchState {
    case fetching
    case success
    case failed
  }

  @ObservableState struct State: Equatable {
    var fetchState: FetchState = .fetching
    var gifList: IdentifiedArrayOf<GifFeature.State> = []
  }

  enum Action {
    case updatePageIndex(Int)
    case fetchGifList
    case feedsResponse(Result<GifList, Error>)
    case gifAction(IdentifiedActionOf<GifFeature>)
  }

  @Dependency(\.redGIFsClient) var redGIFsClient

  var body: some ReducerOf<FeedsFeature> {
    Reduce { state, action in
      switch action {
      case .updatePageIndex(let pageIndex):
        logger.info("on page \(pageIndex)")
        FeedsFeature.currentPageIndex = pageIndex
        let id = state.gifList.elements[pageIndex].id
        return .send(.gifAction(.element(id: id, action: .playerAction(.reset))))
      case .fetchGifList:
        state.fetchState = .fetching
        return .run { send in
          do {
            let gifList = try await self.redGIFsClient.feeds()
            await send(.feedsResponse(.success(gifList)))
          } catch { await send(.feedsResponse(.failure(error))) }
        }
      case .feedsResponse(.success(let gifList)):
        let userMap = Dictionary(uniqueKeysWithValues: gifList.users.map { ($0.username, $0) })
        let nicheMap = Dictionary(uniqueKeysWithValues: gifList.niches.map { ($0.id, $0) })
        state.gifList = IdentifiedArray(
          uniqueElements: gifList.gifs.enumerated()
            .map { index, gif in
              GifFeature.State(
                id: UUID(), gif: gif, user: userMap[gif.userName]!,
                niches: gif.niches.compactMap { niche in nicheMap[niche] }, tags: gif.tags,
                pageIndex: index)
            })
        state.fetchState = .success
        return .none
      case .feedsResponse(.failure(let error)):
        logger.error("fetchGifList error: \(error)")
        state.fetchState = .failed
        return .none
      case .gifAction: return .none
      }
    }
    .forEach(\.gifList, action: \.gifAction) { GifFeature() }
  }
}
