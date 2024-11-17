//
//  PlayerView.swift
//  RedGift
//
//  Created by eliottwang on 2024/11/18.
//

import SwiftUI

import ComposableArchitecture
import Logging
import Player

private let logger = Logger(label: "ren.hazuki.RedGift.Player.PlayerView")

struct PlayerView: UIViewControllerRepresentable {
    let store: StoreOf<PlayerFeature>
    
    func makeUIViewController(context: Context) -> PlayerViewController {
        store.send(.setViewController(PlayerViewController(store: store)))
        return store.viewController!
    }
    
    func updateUIViewController(_ playerViewController: PlayerViewController, context: Context) {
        playerViewController.resetPlayer()
    }
}

class PlayerViewController: UIViewController {
    let store: StoreOf<PlayerFeature> // not duplicate store, because it's a reference
    
    init(store: StoreOf<PlayerFeature>) {
        self.store = store
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func detachPlayer() {
        let player = PlayerFeature.player
        player.playerDelegate = nil
        player.playbackDelegate = nil
        player.willMove(toParent: nil)
        player.view.removeFromSuperview()
        player.removeFromParent()
    }
    
    private func attachPlayer() {
        let player = PlayerFeature.player
        player.playerDelegate = self
        player.playbackDelegate = self
        addChild(player)
        view.addSubview(player.view)
        player.didMove(toParent: self)
    }
    
    private func startPlayer() {
        let player = PlayerFeature.player
        player.url = URL(string: store.urls.hd ?? store.urls.sd)
        player.playbackLoops = true
        player.muted = FeedsFeature.isMuted
        player.playFromBeginning()
    }
    
    func resetPlayer() {
        logger.info("local page index: \(store.pageIndex), global page index: \(FeedsFeature.currentPageIndex)")
        if store.pageIndex == FeedsFeature.currentPageIndex {
            detachPlayer()
            attachPlayer()
            startPlayer()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let player = PlayerFeature.player
        player.view.frame = view.bounds
    }
}

extension PlayerViewController: PlayerDelegate {
    func playerReady(_ player: Player) {
        store.send(.playerReady(player))
    }
    
    func playerPlaybackStateDidChange(_ player: Player) {
        store.send(.playerPlaybackStateDidChange(player))
    }
    
    func playerBufferingStateDidChange(_ player: Player) {
        store.send(.playerBufferingStateDidChange(player))
    }
    
    func playerBufferTimeDidChange(_ bufferTime: Double) {
        store.send(.playerBufferTimeDidChange(bufferTime))
    }
    
    func player(_ player: Player, didFailWithError error: (any Error)?) {
        // TODO: implement callback
    }
}

extension PlayerViewController: PlayerPlaybackDelegate {
    func playerCurrentTimeDidChange(_ player: Player) {
        store.send(.playerCurrentTimeDidChange(player))
    }
    
    func playerPlaybackWillStartFromBeginning(_ player: Player) {
        store.send(.playerPlaybackWillStartFromBeginning(player))
    }
    
    func playerPlaybackDidEnd(_ player: Player) {
        store.send(.playerPlaybackDidEnd(player))
    }
    
    func playerPlaybackWillLoop(_ player: Player) {
        store.send(.playerPlaybackWillLoop(player))
    }
    
    func playerPlaybackDidLoop(_ player: Player) {
        store.send(.playerPlaybackDidLoop(player))
    }
}
