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
            get: { store.currentPageIndex }, set: { store.send(.updatePageIndex($0)) })
        )
        .ignoresSafeArea(edges: .top)

      case .fetching: ProgressView("Fetching feeds...").scaleEffect(1.uiScaled())

      case .failed: Text("No feeds available.").font(.headline).scaleEffect(1.uiScaled())
      }
    }
  }
}

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
