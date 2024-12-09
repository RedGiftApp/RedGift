//
//  RGPlayer.swift
//  RedGift
//
//  Created by eliottwang on 2024/12/8.
//

import AVFoundation
import Player

class RGPlayer: Player {
  weak var delegate: Delegate?

  protocol Delegate: NSObjectProtocol {
    func playerReady(_ player: RGPlayer)
    func playerPlaybackStateDidChange(_ player: RGPlayer)
    func playerBufferingStateDidChange(_ player: RGPlayer)
    func playerBufferTimeDidChange(_ bufferTime: Double)
    func player(_ player: RGPlayer, didFailWithError error: Error?)
    func playerCurrentTimeDidChange(_ player: RGPlayer)
    func playerPlaybackWillStartFromBeginning(_ player: RGPlayer)
    func playerPlaybackDidEnd(_ player: RGPlayer)
    func playerPlaybackWillLoop(_ player: RGPlayer)
    func playerPlaybackDidLoop(_ player: RGPlayer)
  }

  convenience init() { self.init(nibName: nil, bundle: nil) }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    playerDelegate = self
    playbackDelegate = self
  }

  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    playerDelegate = self
    playbackDelegate = self
  }

  override func viewDidLoad() { super.viewDidLoad() }

  deinit {}

  func disableBufferingWait() {
    playerView.player!.automaticallyWaitsToMinimizeStalling = true
    self.bufferSizeInSeconds = 1
  }
}

extension RGPlayer: PlayerDelegate {
  func playerReady(_ player: Player) { delegate?.playerReady(self) }
  func playerPlaybackStateDidChange(_ player: Player) {
    delegate?.playerPlaybackStateDidChange(self)
  }
  func playerBufferingStateDidChange(_ player: Player) {
    delegate?.playerBufferingStateDidChange(self)
  }
  func playerBufferTimeDidChange(_ bufferTime: Double) {
    delegate?.playerBufferTimeDidChange(bufferTime)
  }
  func player(_ player: Player, didFailWithError error: (any Error)?) {
    delegate?.player(self, didFailWithError: error)
  }
}

extension RGPlayer: PlayerPlaybackDelegate {
  func playerCurrentTimeDidChange(_ player: Player) { delegate?.playerCurrentTimeDidChange(self) }
  func playerPlaybackWillStartFromBeginning(_ player: Player) {
    delegate?.playerPlaybackWillStartFromBeginning(self)
  }
  func playerPlaybackDidEnd(_ player: Player) { delegate?.playerPlaybackDidEnd(self) }
  func playerPlaybackWillLoop(_ player: Player) { delegate?.playerPlaybackWillLoop(self) }
  func playerPlaybackDidLoop(_ player: Player) { delegate?.playerPlaybackDidLoop(self) }
}
