//
//  Int+.swift
//  Moyang
//
//  Created by 정김기보 on 2022/07/27.
//

import Foundation

extension Int {
    var ordinal: String? {
        return ordinalFormatter.string(from: NSNumber(value: self))
    }
    
    func withCommas() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        return numberFormatter.string(from: NSNumber(value: self))!
    }
}

private var ordinalFormatter: NumberFormatter = {
    let formatter = NumberFormatter()
    formatter.numberStyle = .ordinal
    return formatter
}()
