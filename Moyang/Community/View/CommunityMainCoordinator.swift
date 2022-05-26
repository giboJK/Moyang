//
//  CommunityMainCoordinator.swift
//  Moyang
//
//  Created by 정김기보 on 2022/05/26.
//

import Foundation
import Swinject
import UIKit

class CommunityMainCoordinator: Coordinator {
    
    var assembler: Assembler
    var nav: UINavigationController
    
    required init(nav: UINavigationController, assembler: Assembler) {
        self.nav = nav
        self.assembler = assembler
    }
    
    required init() {
        nav = UINavigationController()
        assembler = Assembler([])
        Log.e("Coordinator init failed.")
    }
    
    func start(_ animated: Bool, completion: (() -> Void)?) {
        // Do nothing
        if let vc = assembler.resolver.resolve(CommunityMainVC.self) {
            nav.pushViewController(vc, animated: animated)
            vc.coordinator = self
            completion?()
        }
    }
}

extension CommunityMainCoordinator: CommunityMainVCDelegate {
}
