//
//  UINavigationController+.swift
//  Moyang
//
//  Created by 정김기보 on 2021/11/19.
//

import Foundation
import UIKit

extension UINavigationController {
    
    open override func viewWillLayoutSubviews() {
        navigationBar.topItem?.backButtonDisplayMode = .minimal
    }
}
