//
//  FeedsView.swift
//  RedGift
//
//  Created by eliottwang on 2024/11/18.
//

import SwiftUI

import ComposableArchitecture

struct FeedsView: View {
    let store: StoreOf<FeedsFeature>

    var body: some View { ZStack { switch store.fetchState {
    case .success:
        GeometryReader { proxy in
            TabView(selection: Binding(
                get: { FeedsFeature.currentPageIndex },
                set: { store.send(.updatePageIndex($0)) }
            )) {
                ForEach(
                    Array(store.scope(state: \.gifList, action: \.gifAction).enumerated()),
                    id: \.element
                ) { index, store in
                    GifView(store: store)
                        .tag(index)
                        .frame(
                            width: proxy.size.width,
                            height: proxy.size.height
                        )
                }
                .scaledToFill()
                .rotationEffect(.degrees(-90)) // Rotate content
                .frame(
                    width: proxy.size.width,
                    height: proxy.size.height
                )
            }
            .frame(
                width: proxy.size.height, // Height & width swap
                height: proxy.size.width
            )
            .rotationEffect(.degrees(90), anchor: .topLeading) // Rotate TabView
            .offset(x: proxy.size.width) // Offset back into screens bounds
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        }
        .frame(maxWidth: UIScreen.main.bounds.width, maxHeight: UIScreen.main.bounds.height)

    case .fetching:
        ProgressView("Fetching feeds...")

    case .failed:
        Text("No feeds available.")
            .font(.headline)
    }}
    .task {
        store.send(.fetchGifList)
    }
    .preferredColorScheme(.dark)
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
                                id: UUID(),
                                gif: $0,
                                user: GifList.sample.users[0],
                                pageIndex: 0
                            )
                        })
                ),
                reducer: { FeedsFeature() }
            )
        )
    }
}
#endif
