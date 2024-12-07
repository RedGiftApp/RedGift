//
//  SettingsView.swift
//  RedGift
//
//  Created by eliottwang on 2024/12/7.
//

import ComposableArchitecture
import SwiftUI

struct SettingsView: View {
  let store: StoreOf<SettingsFeature>

  var body: some View {
    Form {
      Section(header: Text("Settings")) {
        Toggle(
          "Mute on Start Up",
          isOn: Binding(get: { store.muteOnStartUp }, set: { store.send(.setMuteOnStartUp($0)) }))

        Picker(
          "Scaling Factor",
          selection: Binding(
            get: { store.scalingFactor }, set: { store.send(.setScalingFactor($0)) })
        ) {
          Text("1.0x").tag(1.0)
          Text("1.25x").tag(1.25)
          Text("1.5x").tag(1.5)
          Text("1.75x").tag(1.75)
        }
      }
    }
    .navigationTitle("Settings")
  }
}

struct SettingsView_Previews: PreviewProvider {
  static var previews: some View {
    SettingsView(
      store: Store(
        initialState: SettingsFeature.State(muteOnStartUp: true, scalingFactor: 1.25),
        reducer: { SettingsFeature() }))
  }
}
