//
//  PlayerFeature.swift
//  RedGift
//
//  Created by eliottwang on 2024/11/18.
//

import ComposableArchitecture
import CoreMedia
import Foundation
import Logging
import Player

private let logger = Logger(label: "ren.hazuki.RedGift.Player.PlayerFeature")

@Reducer struct PlayerFeature {
  static let timeStep = 0.05

  @ObservableState struct State: Equatable {
    var player: Player?

    var urls: GifList.Gif.URLs
    var pageIndex: Int

    var currentTime = 0.0
    var bufferTime = 0.0
    var isPaused = false
    var isBuffering = true
    var isShowingPlayPauseAnimation = false
  }

  enum Action: Equatable {
    case createPlayer(PlayerView.Coordinator)
    case updatePlayer(Player)
    case destroyPlayer
    case startPlay
    case seek(Double)
    case togglePause
    case doneShowingPlayPauseAnimation
    case toggleMuted

    // MARK: PlayerDelegate
    case playerReady(Player)
    case playerPlaybackStateDidChange(Player)
    case playerBufferingStateDidChange(Player)
    case playerBufferTimeDidChange(Double)

    // MARK: PlayerPlaybackDelegate
    case playerCurrentTimeDidChange(Player)
    case playerPlaybackWillStartFromBeginning(Player)
    case playerPlaybackDidEnd(Player)
    case playerPlaybackWillLoop(Player)
    case playerPlaybackDidLoop(Player)
  }

  var body: some ReducerOf<PlayerFeature> {
    Reduce { state, action in
      switch action {
      case .createPlayer(let delegate):
        if state.player != nil { return .none }
        logger.log(level: .info, "creating player for page \(state.pageIndex)")
        let player = Player()
        player.playerDelegate = delegate
        player.playbackDelegate = delegate
        player.loadViewIfNeeded()
        player.playbackLoops = true
        player.url = URL(string: state.urls.hd ?? state.urls.sd)
        player.muted = FeedsFeature.isMuted
        state.player = player
        return .none
      case .updatePlayer(let player):
        if state.player == player { return .none }
        logger.log(level: .info, "updating player for page \(state.pageIndex)")
        state.player?.playerDelegate = nil
        state.player?.playbackDelegate = nil
        state.player = player
        return .none
      case .destroyPlayer:
        guard let player = state.player else { return .none }
        logger.log(level: .info, "destroying player for page \(state.pageIndex)")
        player.playerDelegate = nil
        player.playbackDelegate = nil
        state.player = nil
        state.currentTime = 0.0
        state.bufferTime = 0.0
        state.isPaused = false
        state.isBuffering = true
        state.isShowingPlayPauseAnimation = false
        return .none
      case .startPlay:
        state.player!.playFromCurrentTime()
        return .none
      case .seek(let seekTime):
        let target = CMTime(seconds: seekTime, preferredTimescale: CMTimeScale(MSEC_PER_SEC))
        let tolerance = CMTime(
          seconds: PlayerFeature.timeStep / 2, preferredTimescale: CMTimeScale(MSEC_PER_SEC))
        state.player!.seekToTime(to: target, toleranceBefore: tolerance, toleranceAfter: tolerance)
        return .none
      case .togglePause:
        if state.isBuffering || state.isShowingPlayPauseAnimation { return .none }
        let player = state.player!
        if player.playbackState == .paused {
          player.playFromCurrentTime()
        } else if player.playbackState == .playing {
          player.pause()
        } else {
          return .none
        }
        state.isShowingPlayPauseAnimation = true
        return .run { send in
          try await Task.sleep(nanoseconds: 500 * NSEC_PER_MSEC)
          await send(.doneShowingPlayPauseAnimation)
        }
      case .doneShowingPlayPauseAnimation:
        state.isShowingPlayPauseAnimation = false
        return .none
      case .toggleMuted:
        FeedsFeature.isMuted.toggle()
        state.player!.muted = FeedsFeature.isMuted
        return .none

      // MARK: PlayerDelegate
      case .playerReady: return .none
      case .playerPlaybackStateDidChange(let player):
        state.isPaused = player.playbackState == .paused
        return .none
      case .playerBufferingStateDidChange(let player):
        state.isBuffering = player.bufferingState != .ready
        return .none
      case .playerBufferTimeDidChange(let bufferTime):
        state.bufferTime = bufferTime
        return .none

      // MARK: PlayerPlaybackDelegate
      case .playerCurrentTimeDidChange(let player):
        state.currentTime = player.currentTimeInterval
        return .none
      case .playerPlaybackWillStartFromBeginning: return .none
      case .playerPlaybackDidEnd: return .none
      case .playerPlaybackWillLoop: return .none
      case .playerPlaybackDidLoop: return .none
      }
    }
  }
}
