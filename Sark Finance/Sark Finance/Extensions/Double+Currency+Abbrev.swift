//
//  Double+Currency+Abbrev.swift
//  Sark Finance
//
//  Created by Alan Kuo on 3/19/22.
//

import Foundation

extension Double {
    var roundedWithCurrAbbrev: String {
        let number = self
        let thousand = number / 1000
        let million = number / 1000000
        let billion = number / 1000000000
        let trillion = number / 1000000000000
        
        if trillion >= 1.0 {
            return String(format: "$%.2f trillion", locale: Locale.current, trillion)
        }
        
        else if billion >= 1.0 {
            return String(format: "$%.2f billion", locale: Locale.current, billion)
        }
        else if million >= 1.0 {
            return String(format: "$%.2f million", locale: Locale.current, million)
        }
        else if thousand >= 1.0 {
            return String(format: "$%.2f thousand", locale: Locale.current, thousand)
        }
        else {
            return "\(self)"
        }
    }
}
