//
//  MainAssembly.swift
//  Moyang
//
//  Created by 정김기보 on 2022/05/26.
//

import Swinject
import SwinjectAutoregistration
import Foundation
import UIKit

class MainAssembly: Assembly, BaseAssembly {
    var nav: UINavigationController?
    
    deinit { Log.i(self) }
    
    func assemble(container: Container) {
        container.register(MainVC.self) { r in
            let vc = MainVC()
            
            let communityMainVC = r ~> (CommunityMainVC.self)
            communityMainVC.coordinator = r ~> (CommunityMainCoordinator.self)
            vc.communityMainVC = communityMainVC
            
            return vc
        }
        
        container.register(CommunityMainAssembly.self) { _ in
            let assembly = CommunityMainAssembly()
            assembly.nav = self.nav
            return assembly
        }
    }
}
