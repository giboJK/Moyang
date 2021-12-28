//
//  UIApplication+.swift
//  Moyang
//
//  Created by kibo on 2021/12/28.
//

import Foundation
import UIKit

extension UIApplication {
    @nonobjc class var statusBarHeight: CGFloat { UIApplication.shared.connectedScenes
            .filter {$0.activationState == .foregroundActive }
            .map {$0 as? UIWindowScene }
            .compactMap { $0 }
            .first?.windows
            .filter({ $0.isKeyWindow }).first?
            .windowScene?.statusBarManager?.statusBarFrame.height ?? 48 }
    
    @nonobjc class var bottomInset: CGFloat { max(UIApplication.shared
        .windows
        .first?
        .safeAreaInsets.bottom ?? 0, 20) }
}
