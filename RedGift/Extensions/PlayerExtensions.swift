//
//  PlayerExtensions.swift
//  RedGift
//
//  Created by eliottwang on 2024/12/8.
//

import AVFoundation
import Player

extension Player {
  func disableBufferingWait() {
    let mirror = Mirror(reflecting: self)
    for child in mirror.children {
      if let label = child.label, label.contains("_avplayer") {
        (child.value as! AVPlayer).automaticallyWaitsToMinimizeStalling = false
      }
    }
    self.bufferSizeInSeconds = 0
  }
}
