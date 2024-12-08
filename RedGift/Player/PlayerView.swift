//
//  PlayerView.swift
//  RedGift
//
//  Created by eliottwang on 2024/11/18.
//

import ComposableArchitecture
import Player
import SwiftUI

struct PlayerView: UIViewControllerRepresentable {
  let coordinator: Coordinator

  init(store: StoreOf<PlayerFeature>) { coordinator = Coordinator(store: store) }

  func makeUIViewController(context: Context) -> Player {
    return context.coordinator.createPlayer()
  }

  func updateUIViewController(_ uiViewController: Player, context: Context) {}

  static func dismantleUIViewController(_ uiViewController: Player, coordinator: Coordinator) {
    coordinator.destroyPlayer()
  }

  func makeCoordinator() -> Coordinator { return coordinator }

  class Coordinator: NSObject, PlayerDelegate, PlayerPlaybackDelegate {
    private let store: StoreOf<PlayerFeature>

    init(store: StoreOf<PlayerFeature>) { self.store = store }

    func createPlayer() -> Player {
      store.send(.createPlayer(self))
      return store.player!
    }

    func destroyPlayer() { store.send(.destroyPlayer) }

    // MARK: PlayerDelegate
    func playerReady(_ player: Player) { store.send(.playerReady(player)) }

    func playerPlaybackStateDidChange(_ player: Player) {
      store.send(.playerPlaybackStateDidChange(player))
    }

    func playerBufferingStateDidChange(_ player: Player) {
      store.send(.playerBufferingStateDidChange(player))
    }

    func playerBufferTimeDidChange(_ bufferTime: Double) {
      store.send(.playerBufferTimeDidChange(bufferTime))
    }

    func player(_ player: Player, didFailWithError error: Error?) {
      // TODO: implement callback
    }

    // MARK: PlayerPlaybackDelegate
    func playerCurrentTimeDidChange(_ player: Player) {
      store.send(.playerCurrentTimeDidChange(player))
    }

    func playerPlaybackWillStartFromBeginning(_ player: Player) {
      store.send(.playerPlaybackWillStartFromBeginning(player))
    }

    func playerPlaybackDidEnd(_ player: Player) { store.send(.playerPlaybackDidEnd(player)) }

    func playerPlaybackWillLoop(_ player: Player) { store.send(.playerPlaybackWillLoop(player)) }

    func playerPlaybackDidLoop(_ player: Player) { store.send(.playerPlaybackDidLoop(player)) }
  }
}
