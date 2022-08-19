//
//  String+.swift
//  Moyang
//
//  Created by 정김기보 on 2022/01/21.
//

import UIKit

extension String {
    static func randomString(length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).map { _ in letters.randomElement()! })
    }
}

extension String {
    var isValidEmail: Bool {
        let name = "[A-Z0-9a-z]([A-Z0-9a-z._%+-]{0,30}[A-Z0-9a-z])?"
        let domain = "([A-Z0-9a-z]([A-Z0-9a-z-]{0,30}[A-Z0-9a-z])?\\.){1,5}"
        let emailRegEx = name + "@" + domain + "[A-Za-z]{2,8}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailPredicate.evaluate(with: self)
    }
}

extension String {
    func isoToDateString(_ format: String = "yyyy년 MM월 dd일 hh:mm a") -> String? {
        if let removeMilliSec = self.split(separator: ".").first {
            let timeString = String(removeMilliSec)+"+00:00"
            let formatter = DateFormatter()
            formatter.locale = .current
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            formatter.timeZone = TimeZone.current
            if let date = formatter.date(from: timeString) {
                return date.toString(format)
            }
        }
        return nil
    }
    
    func isoToDate() -> Date? {
        if let removeMilliSec = self.split(separator: ".").first {
            let timeString = String(removeMilliSec)+"+00:00"
            let formatter = DateFormatter()
            formatter.locale = .current
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            formatter.timeZone = TimeZone.current
            if let date = formatter.date(from: timeString) {
                return date
            }
        }
        return nil
    }
}

extension String {
    func toDate(_ format: String = "yyyy-MM-dd HH:mm:ss") -> Date? {

        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Tehran")
        dateFormatter.locale = Locale(identifier: "fa-IR")
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.dateFormat = format
        let date = dateFormatter.date(from: self)

        return date
    }
    
    /**
     * 지정한 폰트로 글을 적었을때 높이
     */
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin,
                                            attributes: [NSAttributedString.Key.font: font], context: nil)
        return ceil(boundingBox.height)
    }
    
    /**
     * 지정한 폰트로 글을 적었을때 너비
     */
    func width(withConstraintedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin,
                                            attributes: [NSAttributedString.Key.font: font], context: nil)
        return ceil(boundingBox.width)
    }
}
