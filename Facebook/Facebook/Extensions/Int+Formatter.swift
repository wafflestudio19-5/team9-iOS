//
//  Int+Formatter.swift
//  Facebook
//
//  Created by 박신홍 on 2021/12/19.
//

import Foundation

extension Int {
    func withCommas(unit: String? = nil) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        let formatted = numberFormatter.string(from: NSNumber(value: self))
        guard let formatted = formatted else {
            return "NaN"
        }
        guard let unit = unit else {
            return formatted
        }
        return "\(formatted)\(unit)"
    }
}
