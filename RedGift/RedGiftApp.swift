//
//  RedGiftApp.swift
//  RedGift
//
//  Created by eliottwang on 2024/11/18.
//

import AVFoundation
import ComposableArchitecture
import SwiftUI

final class AppDelegate: NSObject, UIApplicationDelegate {
  override public init() {
    isPerceptionCheckingEnabled = false
    try! AVAudioSession.sharedInstance()
      .setCategory(.playback, mode: .moviePlayback, options: .duckOthers)
  }
}

@main struct RedGiftApp: App {
  @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

  static let store = Store(
    initialState: FeedsFeature.State(
      gifList: IdentifiedArray(
        uniqueElements: GifList.sample.gifs.enumerated()
          .map { index, gif in
            GifFeature.State(
              id: UUID(), gif: gif, user: GifList.sample.users[index],
              niches: GifList.sample.niches, tags: GifList.sample.tags, pageIndex: index)
          })), reducer: { FeedsFeature() })

  var body: some Scene { WindowGroup { FeedsView(store: Self.store) } }
}
