//
//  NSStringExtensions.swift
//  RedGift
//
//  Created by eliottwang on 2024/11/19.
//

import UIKit

extension NSString {
    func truncatingIndexToDisplayOnSingleLine(font: UIFont, width: CGFloat, truncateWithinWord: Bool = false) -> Int {
        let indexOfFirstNewLineChar = self.rangeOfCharacter(from: .newlines).location
        let upperBound = indexOfFirstNewLineChar == NSNotFound ? self.length : indexOfFirstNewLineChar + 1

        // binary search to find longest substring within width
        var l = 0
        var r = upperBound
        while l < r {
            let mid = (l + r + 1) / 2
            if self.substring(to: mid).size(withAttributes: [NSAttributedString.Key.font: font]).width > width {
                r = mid - 1
            } else {
                l = mid
            }
        }

        if truncateWithinWord || l == 0 || l == upperBound {
            return l
        }

        // check if the current truncate point is within a word
        var prevWordSubrange: NSRange = .init()
        var nextWordSubrange: NSRange = .init()
        self.enumerateSubstrings(in: NSMakeRange(0, l), options: [.byWords, .reverse, .localized]) { _, subrange, _, stop in
            prevWordSubrange = subrange
            stop.pointee = true
        }
        self.enumerateSubstrings(in: NSMakeRange(l, upperBound - l), options: [.byWords, .localized]) { _, subrange, _, stop in
            nextWordSubrange = subrange
            stop.pointee = true
        }
        if prevWordSubrange.upperBound == nextWordSubrange.location {
            return prevWordSubrange.location
        }

        return l
    }
}
