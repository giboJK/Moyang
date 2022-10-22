//
//  MoyangLabel.swift
//  Moyang
//
//  Created by 정김기보 on 2022/10/22.
//

import UIKit

class MoyangLabel: UILabel {

    override var font: UIFont! {
        didSet {
            self.setupLabelTypography()
        }
    }
    
    // 동적으로 값이 계속 바뀌는 경우를 위해 추가됨
    override var text: String? {
        didSet {
            self.setupLabelTypography()
        }
    }
    
    var topInset: CGFloat = 0.0
    var bottomInset: CGFloat = 0.0
    var leftInset: CGFloat = 0.0
    var rightInset: CGFloat = 0.0
    
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawText(in: rect.inset(by: insets))
    }
    
    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + leftInset + rightInset,
                      height: size.height + topInset + bottomInset)
    }
    
    override var bounds: CGRect {
        didSet {
            // ensures this works within stack views if multi-line
            preferredMaxLayoutWidth = bounds.width - (leftInset + rightInset)
        }
    }
    
    init() {
        super.init(frame: .zero)
    }
    
    init(padding: UIEdgeInsets) {
        super.init(frame: .zero)
        topInset = padding.top
        bottomInset = padding.bottom
        leftInset = padding.left
        rightInset = padding.right
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLabelTypography() {
        let textAlignment = self.textAlignment
        let textColor = self.textColor
        let widthRatio = UIScreen.main.bounds.width / 390
        switch font {
            // MARK: - Title
        case Fonts.Title.t01:
            self.letterSpacing = 0.72 * widthRatio
        case Fonts.Title.t02:
            self.letterSpacing = 0.56 * widthRatio
        case Fonts.Title.t03:
            self.letterSpacing = 0.48 * widthRatio
        case Fonts.Title.t04:
            self.letterSpacing = 0.44 * widthRatio
        case Fonts.Title.headline:
            self.letterSpacing = 0.36 * widthRatio
            
        default:
            self.letterSpacing = widthRatio
        }
        self.textAlignment = textAlignment
        self.textColor = textColor
    }
    
    override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        var textRect = super.textRect(forBounds: bounds, limitedToNumberOfLines: numberOfLines)
        textRect.origin.y = bounds.origin.y + (bounds.size.height - textRect.size.height) * 0.5
        
        return textRect
    }
}

extension UILabel {
    var letterSpacing: CGFloat? {
        get { getAttribute(.kern) }
        set { setAttribute(.kern, value: newValue) }
    }
    
    fileprivate var attributes: [NSAttributedString.Key: Any]? {
        if let attributedText = attributedText {
            return attributedText.attributes(at: 0, effectiveRange: nil)
        } else {
            return nil
        }
    }
    
    fileprivate func getAttribute<AttributeType>(_ key: NSAttributedString.Key) -> AttributeType? {
        return attributes?[key] as? AttributeType
    }
    
    fileprivate func setAttribute(_ key: NSAttributedString.Key, value: Any?) {
        if let value = value {
            addAttribute(key, value: value)
        } else {
            removeAttribute(key)
        }
    }
    
    fileprivate func addAttribute(_ key: NSAttributedString.Key, value: Any) {
        if let attributedText = attributedText {
            let mutableAttributedText = NSMutableAttributedString(attributedString: attributedText)
            mutableAttributedText.addAttribute(key, value: value, range: attributedText.entireRange)
            self.attributedText = mutableAttributedText
        } else {
            self.attributedText = NSAttributedString(string: text ?? "", attributes: attributes)
        }
    }
    
    fileprivate func removeAttribute(_ key: NSAttributedString.Key) {
        if let attributedText = attributedText {
            let mutableAttributedText = NSMutableAttributedString(attributedString: attributedText)
            mutableAttributedText.removeAttribute(key, range: attributedText.entireRange)
            self.attributedText = mutableAttributedText
        }
    }
}

extension NSAttributedString {
    
    var entireRange: NSRange {
        NSRange(location: 0, length: self.length)
    }
}
