//
//  UITextView+.swift
//  Moyang
//
//  Created by kibo on 2022/11/30.
//

import UIKit

extension UITextView {
    func numberOfLines() -> Int {
        let layoutManager = self.layoutManager
        let numberOfGlyphs = layoutManager.numberOfGlyphs
        var lineRange: NSRange = NSMakeRange(0, 1)
        var index = 0
        var numberOfLines = 0

        while index < numberOfGlyphs {
            layoutManager.lineFragmentRect(
                forGlyphAt: index, effectiveRange: &lineRange
            )
            index = NSMaxRange(lineRange)
            numberOfLines += 1
        }
        if let lastChar = self.text.last {
            if lastChar == "\n" {
                numberOfLines += 1
            }
        }
        return numberOfLines
    }
}

