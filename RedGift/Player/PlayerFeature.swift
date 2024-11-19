//
//  PlayerFeature.swift
//  RedGift
//
//  Created by eliottwang on 2024/11/18.
//

import Foundation

import ComposableArchitecture
import CoreMedia
import Player

@Reducer
struct PlayerFeature {
    static let player = Player()
    static let timeStep = 0.05
    
    @ObservableState
    struct State: Equatable {
        var viewController: PlayerViewController? = nil
        
        var urls: GifList.Gif.URLs
        
        var pageIndex: Int
        
        var currentTime = 0.0
        var bufferTime = 0.0
        var isPaused = false
        var isBuffering = true
        var isShowingPlayPauseAnimation = false
    }
    
    enum Action: Equatable {
        case reset
        case seek(Double)
        case togglePause
        case doneShowingPlayPauseAnimation
        case toggleMuted
        case setViewController(PlayerViewController)
        
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
            case .reset:
                state.viewController!.resetPlayer()
                return .none
            case .seek(let seekTime):
                let target = CMTime(seconds: seekTime, preferredTimescale: CMTimeScale(MSEC_PER_SEC))
                let tolerance = CMTime(seconds: PlayerFeature.timeStep / 2, preferredTimescale: CMTimeScale(MSEC_PER_SEC))
                PlayerFeature.player.seekToTime(to: target, toleranceBefore: tolerance, toleranceAfter: tolerance)
                return .none
            case .togglePause:
                if state.isBuffering || state.isShowingPlayPauseAnimation {
                    return .none
                }
                let player = PlayerFeature.player
                if player.playbackState == .paused {
                    player.playFromCurrentTime()
                    state.isPaused = false
                } else if player.playbackState == .playing {
                    player.pause()
                    state.isPaused = true
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
                PlayerFeature.player.muted = FeedsFeature.isMuted
                return .none
            case .setViewController(let viewController):
                state.viewController = viewController
                return .none
                
            // MARK: PlayerDelegate
            case .playerReady:
                return .none
            case .playerPlaybackStateDidChange:
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
            case .playerPlaybackWillStartFromBeginning:
                return .none
            case .playerPlaybackDidEnd:
                return .none
            case .playerPlaybackWillLoop:
                return .none
            case .playerPlaybackDidLoop:
                return .none
            }
        }
    }
}
