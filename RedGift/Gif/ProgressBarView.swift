//
//  ProgressBarView.swift
//  RedGift
//
//  Created by eliottwang on 2024/11/30.
//

import SwiftUI

struct ProgressBar: View {
  let bufferTime: Double
  let currentTime: Double
  let totalDuration: Double
  let onSeek: (Double) -> Void

  var body: some View {
    Impl(
      bufferTime: Binding(get: { bufferTime }, set: { _ in }),
      currentTime: Binding(get: { currentTime }, set: { onSeek($0) }), totalDuration: totalDuration
    )
    .clipped()
  }

  private struct Impl: UIViewRepresentable {
    @Binding var bufferTime: Double
    @Binding var currentTime: Double
    let totalDuration: Double

    enum Tag {
      static let uiProgressView = UIProgressView.hash()
      static let uiSlider = UISlider.hash()
    }

    class Coordinator: NSObject {
      var value: Binding<Double>

      init(value: Binding<Double>) { self.value = value }

      @objc func valueChanged(_ sender: UISlider) { value.wrappedValue = Double(sender.value) }
    }

    func makeCoordinator() -> Coordinator { Coordinator(value: $currentTime) }

    class UISliderImpl: UISlider {
      override func trackRect(forBounds bounds: CGRect) -> CGRect {
        var res = super.trackRect(forBounds: bounds)
        res.size.height = 3
        return res
      }
    }

    func makeUIView(context: Context) -> UIView {
      let progressView = UIProgressView()
      progressView.tag = Tag.uiProgressView
      progressView.translatesAutoresizingMaskIntoConstraints = false
      progressView.progressImage = UIImage(named: "ProgressBar/Buffer")
      progressView.trackTintColor = .clear

      let slider = UISliderImpl()
      slider.tag = Tag.uiSlider
      slider.addTarget(
        context.coordinator, action: #selector(Coordinator.valueChanged(_:)), for: .valueChanged)
      slider.translatesAutoresizingMaskIntoConstraints = false
      slider.setMinimumTrackImage(UIImage(named: "ProgressBar/Seek"), for: .normal)
      slider.setThumbImage(UIImage(named: "ProgressBar/Thumb"), for: .normal)
      slider.maximumTrackTintColor = .clear
      slider.maximumValue = Float(totalDuration)

      let containerView = UIView()
      containerView.addSubview(progressView)
      containerView.addSubview(slider)
      NSLayoutConstraint.activate([
        progressView.widthAnchor.constraint(equalTo: containerView.widthAnchor),
        progressView.heightAnchor.constraint(equalToConstant: 3),
        progressView.topAnchor.constraint(equalTo: containerView.topAnchor),
        slider.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
        slider.topAnchor.constraint(equalTo: containerView.topAnchor, constant: -14),
        slider.widthAnchor.constraint(equalTo: containerView.widthAnchor, constant: 31),
        slider.heightAnchor.constraint(equalToConstant: 31),
      ])
      return containerView
    }

    func updateUIView(_ view: UIView, context: Context) {
      if let progressView = view.viewWithTag(Tag.uiProgressView) as? UIProgressView {
        progressView.progress = Float(bufferTime / totalDuration)
      }
      if let slider = view.viewWithTag(Tag.uiSlider) as? UISlider {
        slider.value = Float(currentTime)
      }
    }
  }
}

#if DEBUG
  struct ProgressBarView_Previews: PreviewProvider {
    static var previews: some View {
      ProgressBar(bufferTime: 66, currentTime: 33, totalDuration: 100) { _ in }
    }
  }
#endif
