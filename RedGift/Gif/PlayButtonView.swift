//
//  PlayButtonView.swift
//  RedGift
//
//  Created by eliottwang on 2024/11/29.
//

import SwiftUI

struct PlayButtonView: View {
  var doShow: Bool

  var body: some View {
    if doShow {
      Image("Player/PlayButton").scaleEffect(1.uiScaled())
        .shadow(color: .black, radius: 5, x: 1, y: 0)
    }
  }
}

#if DEBUG
  struct PlayButtonView_Previews: PreviewProvider {
    static var previews: some View {
      ZStack {
        Color.red
        PlayButtonView(doShow: true)
      }
    }
  }
#endif
