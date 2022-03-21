//
//  Double+FormatCurrency.swift
//  Sark Finance
//
//  Created by Alan Kuo on 3/21/22.
//

import Foundation

extension Formatter {
    static let withSeparator: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: "en_US") //for USA's currency patter
        formatter.numberStyle = .currency
        return formatter
    }()
}

extension Numeric {
    var currencyWithSeparator: String {
        return Formatter.withSeparator.string(for: self) ?? ""
    }
}
