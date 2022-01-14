//
//  Font+.swift
//  Moyang
//
//  Created by kibo on 2022/01/11.
//

import SwiftUI

public extension Font {
  init(uiFont: UIFont) {
    self = Font(uiFont as CTFont)
  }
}
