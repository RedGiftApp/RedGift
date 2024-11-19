//
//  ProgressViewEx.swift
//  RedGift
//
//  Created by eliottwang on 2024/11/19.
//

import SwiftUI

struct ProgressViewEx: UIViewRepresentable {
    var progressColor: UIColor?
    var trackColor: UIColor?
    var style: UIProgressView.Style = .default

    @Binding var progress: Double

    func makeUIView(context: Context) -> UIProgressView {
        let progressView = UIProgressView(frame: .zero)
        progressView.progressTintColor = progressColor
        progressView.trackTintColor = trackColor
        progressView.progressViewStyle = style
        progressView.progress = Float(progress)

        return progressView
    }

    func updateUIView(_ uiView: UIProgressView, context: Context) {
        // Coordinating data between UIView and SwiftUI view
        uiView.progress = Float(progress)
    }
}

#if DEBUG
struct ProgressViewEx_Previews: PreviewProvider {
    static var previews: some View {
        ProgressViewEx(
            progressColor: .blue,
            trackColor: .green,
            progress: .constant(0.5)
        )
    }
}
#endif
