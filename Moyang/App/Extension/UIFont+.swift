//
//  UIFont+.swift
//  Moyang
//
//  Created by 정김기보 on 2022/10/22.
//

import UIKit

extension UIFont {
    
    // MARK: - Title
    @nonobjc class var t01: UIFont { Fonts.Title.t01 }
    @nonobjc class var t02: UIFont { Fonts.Title.t02 }
    @nonobjc class var t03: UIFont { Fonts.Title.t03 }
    @nonobjc class var t04: UIFont { Fonts.Title.t04 }
    @nonobjc class var headline: UIFont { Fonts.Title.headline }
    
    // MARK: - Body
    @nonobjc class var b01: UIFont { Fonts.Body.b01 }
    @nonobjc class var b02: UIFont { Fonts.Body.b02 }
    @nonobjc class var b03: UIFont { Fonts.Body.b03 }
    @nonobjc class var b04: UIFont { Fonts.Body.b04 }
    @nonobjc class var b05: UIFont { Fonts.Body.b05 }
    
    // MARK: - Caption
    @nonobjc class var c01: UIFont { Fonts.Caption.c01 }
    @nonobjc class var c02: UIFont { Fonts.Caption.c02 }
    @nonobjc class var c03: UIFont { Fonts.Caption.c03 }
    @nonobjc class var c04: UIFont { Fonts.Caption.c04 }
    
    class func systemRelativeFont(ofSize fontSize: CGFloat, weight: UIFont.Weight) -> UIFont {
        let ratio = UIScreen.main.bounds.width / 390
        let fixedFont = fontSize * ratio
        return .systemFont(ofSize: fixedFont, weight: weight)
    }
}
