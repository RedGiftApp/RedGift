//
//  TextEx.swift
//  RedGift
//
//  Created by eliottwang on 2024/11/20.
//

import SwiftUI

struct TextEx: View {
    let desc: NSString
    let size: CGFloat
    let color: Color

    var body: some View { if desc.length > 0 { WidthReader { maxWidth in ZStack {
        let uiFont: UIFont = .systemFont(ofSize: size)
        let font: Font = .system(size: size)
        let truncatingIndex = desc.truncatingIndexToDisplayOnSingleLine(font: uiFont, width: maxWidth - 18)

        if truncatingIndex < desc.length {
            DisclosureGroup(content: {
                Text(desc.substring(from: truncatingIndex).trimmingCharacters(in: .whitespacesAndNewlines))
                    .font(font)
                    .lineSpacing(4)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }, label: {
                Text(desc.substring(to: truncatingIndex).trimmingCharacters(in: .whitespacesAndNewlines))
                    .font(font)
                    .frame(maxWidth: .infinity, alignment: .leading)
            })
        } else {
            Text(desc.trimmingCharacters(in: .whitespacesAndNewlines))
                .font(font)
        }
    }}
    .foregroundStyle(color)
    }}
}

#if DEBUG
struct TextEx_Previews: PreviewProvider {
    static var previews: some View {
        TextEx(desc: "这是一段比较长的测试文本，用于测试SwiftUI中文本是否能够在一行内显示的动态调整。", size: 21, color: .gray)
    }
}
#endif
