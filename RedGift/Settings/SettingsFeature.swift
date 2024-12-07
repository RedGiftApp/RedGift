//
//  SettingsFeature.swift
//  RedGift
//
//  Created by eliottwang on 2024/12/7.
//

import ComposableArchitecture
import Foundation

@Reducer struct SettingsFeature {
  static let kMuteOnStartUpKey = "Setting.MuteOnStartUp"
  static let kScalingFactorKey = "Setting.ScalingFactor"

  @ObservableState struct State: Equatable {
    var muteOnStartUp = true
    var scalingFactor = 1.25
  }

  enum Action {
    case setMuteOnStartUp(Bool)
    case setScalingFactor(Double)
  }

  var body: some ReducerOf<SettingsFeature> {
    Reduce { state, action in
      switch action {
      case .setMuteOnStartUp(let muteOnStartUp):
        state.muteOnStartUp = muteOnStartUp
        UserDefaults.standard.set(muteOnStartUp, forKey: Self.kMuteOnStartUpKey)
        return .none
      case .setScalingFactor(let scalingFactor):
        state.scalingFactor = scalingFactor
        UserDefaults.standard.set(scalingFactor, forKey: Self.kScalingFactorKey)
        return .none
      }
    }
  }
}
