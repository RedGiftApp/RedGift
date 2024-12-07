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

    UserDefaults.standard.register(defaults: [
      SettingsFeature.kMuteOnStartUpKey: true, SettingsFeature.kScalingFactorKey: 1.25,
    ])

    RedGiftApp.settingsStore.send(
      .setMuteOnStartUp(UserDefaults.standard.bool(forKey: SettingsFeature.kMuteOnStartUpKey)))
    RedGiftApp.settingsStore.send(
      .setScalingFactor(UserDefaults.standard.double(forKey: SettingsFeature.kScalingFactorKey)))

    RedGiftApp.feedsStore.send(.fetchGifList)
  }
}

@main struct RedGiftApp: App {
  @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

  static let feedsStore = Store(
    initialState: FeedsFeature.State(
      gifList: IdentifiedArray(
        uniqueElements: GifList.sample.gifs.enumerated()
          .map { index, gif in
            GifFeature.State(
              id: UUID(), gif: gif, user: GifList.sample.users[index],
              niches: GifList.sample.niches, tags: GifList.sample.tags, pageIndex: index)
          })), reducer: { FeedsFeature() })

  static let settingsStore = Store(
    initialState: SettingsFeature.State(), reducer: { SettingsFeature() })

  var body: some Scene {
    WindowGroup {
      TabView {
        FeedsView(store: Self.feedsStore).tabItem { Label("Feeds", systemImage: "list.bullet") }

        SettingsView(store: Self.settingsStore)
          .tabItem { Label("Settings", systemImage: "gearshape") }
      }
    }
  }
}
