//
//  Integer+Abbreviations.swift
//  Sark Finance
//
//  Created by Alan Kuo on 3/19/22.
//

import Foundation

extension Int {
    var roundedWithAbbrev: String {
        let number = Double(self)
        let thousand = number / 1000
        let million = number / 1000000
            let billion = number / 1000000000
        if billion >= 1.0 {
            return "\(round(billion*100)/100) billion"
            
        }
        else if million >= 1.0 {
            return "\(round(million*100)/100) million"
        }
        else if thousand >= 1.0 {
            return "\(round(thousand*100)/100) thousand"
        }
        else {
            return "\(self)"
        }
    }
}

