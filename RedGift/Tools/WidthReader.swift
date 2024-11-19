//
//  WidthReader.swift
//  RedGift
//
//  Created by eliottwang on 2024/11/20.
//

import SwiftUI

struct WidthReader<Content: View>: View {
    let widthContent: (CGFloat) -> Content
    @State private var width: CGFloat = 0
    @State private var height: CGFloat = 0
    var body: some View {
        GeometryReader { g in
            widthContent(width).background(
                GeometryReader { g1 in
                    Spacer().onAppear { height = g1.size.height }.onChange(of: g1.size.height, perform: { height = $0 })
                }
            ).onAppear { width = g.size.width }.onChange(of: g.size.width, perform: { width = $0 })
        }.frame(height: height)
    }
}
