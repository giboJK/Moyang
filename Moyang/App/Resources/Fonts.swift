//
//  Fonts.swift
//  Moyang
//
//  Created by 정김기보 on 2022/10/22.
//


import UIKit

internal enum Fonts {
    internal enum Title {
        internal static let t01 = UIFont.systemRelativeFont(ofSize: 36, weight: .heavy)
        internal static let t02 = UIFont.systemRelativeFont(ofSize: 28, weight: .heavy)
        internal static let t03 = UIFont.systemRelativeFont(ofSize: 24, weight: .heavy)
        internal static let t04 = UIFont.systemRelativeFont(ofSize: 22, weight: .heavy)
        internal static let headline = UIFont.systemRelativeFont(ofSize: 18, weight: .heavy)
    }
    internal enum Body {
        internal static let b01 = UIFont.systemRelativeFont(ofSize: 16, weight: .heavy)
        internal static let b02 = UIFont.systemRelativeFont(ofSize: 16, weight: .medium)
        internal static let b03 = UIFont.systemRelativeFont(ofSize: 14, weight: .heavy)
        internal static let b04 = UIFont.systemRelativeFont(ofSize: 14, weight: .medium)
        internal static let b05 = UIFont.systemRelativeFont(ofSize: 14, weight: .regular)
    }
    internal enum Caption {
        internal static let c01 = UIFont.systemRelativeFont(ofSize: 12, weight: .heavy)
        internal static let c02 = UIFont.systemRelativeFont(ofSize: 12, weight: .medium)
        internal static let c03 = UIFont.systemRelativeFont(ofSize: 10, weight: .heavy)
        internal static let c04 = UIFont.systemRelativeFont(ofSize: 10, weight: .medium)
    }
}
