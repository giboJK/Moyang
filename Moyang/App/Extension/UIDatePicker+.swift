//
//  UIDatePicker+.swift
//  Moyang
//
//  Created by 정김기보 on 2022/11/06.
//

import UIKit


extension UIDatePicker {

   func setDate(from string: String, format: String, animated: Bool = true) {

      let formater = DateFormatter()

      formater.dateFormat = format

      let date = formater.date(from: string) ?? Date()

      setDate(date, animated: animated)
   }
}
