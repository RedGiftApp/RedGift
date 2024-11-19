//
//  IntExtensions.swift
//  RedGift
//
//  Created by eliottwang on 2024/11/17.
//

import Foundation

extension Int {
    func prettyFormat() -> String {
        if self >= 1_000_000_000 {
            return String(format: "%.1fb", Double(self) / 1_000_000_000)
        } else if self >= 1_000_000 {
            return String(format: "%.1fm", Double(self) / 1_000_000)
        } else if self >= 1_000 {
            return String(format: "%.1fk", Double(self) / 1_000)
        } else {
            return "\(self)"
        }
    }

    func prettyDate() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        formatter.locale = Locale(identifier: "en_US")
        return formatter.string(from: Date(timeIntervalSince1970: Double(self)))
    }
}