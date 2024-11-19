//
//  SliderEx.swift
//  RedGift
//
//  Created by eliottwang on 2024/11/19.
//

import SwiftUI

struct SliderEx: UIViewRepresentable {
    final class Coordinator: NSObject {
        // The class property value is a binding: It’s a reference to the SliderEx
        // value, which receives a reference to a @State variable value in ContentView.
        var value: Binding<Double>

        // Create the binding when you initialize the Coordinator
        init(value: Binding<Double>) {
            self.value = value
        }

        // Create a valueChanged(_:) action
        @objc func valueChanged(_ sender: UISlider) {
            value.wrappedValue = Double(sender.value)
        }
    }

    var thumbColor: UIColor = .white
    var minTrackColor: UIColor?
    var maxTrackColor: UIColor?

    @Binding var value: Double

    func makeUIView(context: Context) -> UISlider {
        let slider = UISlider(frame: .zero)
        slider.thumbTintColor = thumbColor
        slider.minimumTrackTintColor = minTrackColor
        slider.maximumTrackTintColor = maxTrackColor
        slider.value = Float(value)

        slider.addTarget(
            context.coordinator,
            action: #selector(Coordinator.valueChanged(_:)),
            for: .valueChanged
        )

        return slider
    }

    func updateUIView(_ uiView: UISlider, context: Context) {
        // Coordinating data between UIView and SwiftUI view
        uiView.value = Float(value)
    }

    func makeCoordinator() -> SliderEx.Coordinator {
        Coordinator(value: $value)
    }
}

#if DEBUG
struct SliderEx_Previews: PreviewProvider {
    static var previews: some View {
        SliderEx(
            thumbColor: .white,
            minTrackColor: .blue,
            maxTrackColor: .green,
            value: .constant(0.5)
        )
    }
}
#endif
