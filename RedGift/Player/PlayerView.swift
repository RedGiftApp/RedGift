//
//  PlayerView.swift
//  RedGift
//
//  Created by eliottwang on 2024/11/18.
//

import ComposableArchitecture
import SwiftUI

struct PlayerView: UIViewControllerRepresentable {
  let coordinator: Coordinator

  init(store: StoreOf<PlayerFeature>) { coordinator = Coordinator(store: store) }

  func makeUIViewController(context: Context) -> RGPlayer {
    return context.coordinator.createPlayer()
  }

  func updateUIViewController(_ uiViewController: RGPlayer, context: Context) {}

  static func dismantleUIViewController(_ uiViewController: RGPlayer, coordinator: Coordinator) {
    coordinator.destroyPlayer()
  }

  func makeCoordinator() -> Coordinator { return coordinator }

  class Coordinator: NSObject, RGPlayer.Delegate {
    private let store: StoreOf<PlayerFeature>

    init(store: StoreOf<PlayerFeature>) { self.store = store }

    func createPlayer() -> RGPlayer {
      store.send(.createPlayer(self))
      return store.player!
    }

    func destroyPlayer() { store.send(.destroyPlayer) }

    // MARK: RGPlayer.Delegate
    func playerReady(_ player: RGPlayer) { store.send(.playerReady(player)) }

    func playerPlaybackStateDidChange(_ player: RGPlayer) {
      store.send(.playerPlaybackStateDidChange(player))
    }

    func playerBufferingStateDidChange(_ player: RGPlayer) {
      store.send(.playerBufferingStateDidChange(player))
    }

    func playerBufferTimeDidChange(_ bufferTime: Double) {
      store.send(.playerBufferTimeDidChange(bufferTime))
    }

    func player(_ player: RGPlayer, didFailWithError error: Error?) {
      // TODO: implement callback
    }

    func playerCurrentTimeDidChange(_ player: RGPlayer) {
      store.send(.playerCurrentTimeDidChange(player))
    }

    func playerPlaybackWillStartFromBeginning(_ player: RGPlayer) {
      store.send(.playerPlaybackWillStartFromBeginning(player))
    }

    func playerPlaybackDidEnd(_ player: RGPlayer) { store.send(.playerPlaybackDidEnd(player)) }

    func playerPlaybackWillLoop(_ player: RGPlayer) { store.send(.playerPlaybackWillLoop(player)) }

    func playerPlaybackDidLoop(_ player: RGPlayer) { store.send(.playerPlaybackDidLoop(player)) }
  }
}
