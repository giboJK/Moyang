//
//  NavigationUtil.swift
//  Moyang
//
//  Created by kibo on 2022/02/13.
//

import Foundation
import UIKit

struct NavigationUtil {
    static func popToRootView() {
        findNavigationController(viewController: UIApplication.keyWindow?.rootViewController)?
            .popToRootViewController(animated: true)
    }
    
    static func findNavigationController(viewController: UIViewController?) -> UINavigationController? {
        guard let viewController = viewController else {
            return nil
        }
        
        if let navigationController = viewController as? UINavigationController {
            return navigationController
        }
        
        for childViewController in viewController.children {
            return findNavigationController(viewController: childViewController)
        }
        
        if let nav = viewController.navigationController {
            return nav
        }
        
        return nil
    }
}
