//
//  FeedsView.swift
//  RedGift
//
//  Created by eliottwang on 2024/11/18.
//

import ComposableArchitecture
import SwiftUI

struct FeedsView: View {
  let store: StoreOf<FeedsFeature>

  var body: some View {
    ZStack {
      switch store.fetchState {
      case .success:
        PageView(
          pages: store.scope(state: \.gifList, action: \.gifAction)
            .map { store in GifView(store: store) },
          currentPage: Binding(
            get: { FeedsFeature.currentPageIndex }, set: { store.send(.updatePageIndex($0)) }))

      case .fetching: ProgressView("Fetching feeds...")

      case .failed: Text("No feeds available.").font(.headline)
      }
    }
    .task { store.send(.fetchGifList) }
  }
}

#if DEBUG
  struct FeedsView_Previews: PreviewProvider {
    static var previews: some View {
      FeedsView(
        store: Store(
          initialState: FeedsFeature.State(
            gifList: IdentifiedArray(
              uniqueElements: GifList.sample.gifs.map {
                GifFeature.State(
                  id: UUID(), gif: $0, user: GifList.sample.users[0], niches: GifList.sample.niches,
                  tags: GifList.sample.tags, pageIndex: 0)
              })), reducer: { FeedsFeature() }))
    }
  }
#endif
