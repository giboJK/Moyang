//
//  MediatorPrayAssembly.swift
//  Moyang
//
//  Created by kibo on 2022/10/24.
//

import Swinject
import SwinjectAutoregistration
import Foundation
import UIKit

class MediatorPrayAssembly: Assembly, BaseAssembly {
    var nav: UINavigationController?
    
    deinit { Log.i(self) }
    
    func assemble(container: Container) {
        container.register(NetworkServiceProtocol.self) { _ in
            AFNetworkService(sessionConfiguration: .default)
        }
        
        // MARK: - MediatorPrayMainVC
        
        container.register(MediatorPrayMainVC.self) { r in
            let vc = MediatorPrayMainVC()
            vc.vm = (r ~> MediatorPrayMainVM.self)
            vc.coordinator = r ~> (MediatorPrayCoordinator.self)
            
            // View controllers
            
            return vc
        }
        container.register(MediatorPrayMainVM.self) { _ in
            MediatorPrayMainVM()
        }
        
        
        // MARK: - Coordinator
        container.register(MediatorPrayCoordinator.self) { _ in
            guard let nav = self.nav else { return MediatorPrayCoordinator() }
            let coordinator = MediatorPrayCoordinator(nav: nav, assembler: Assembler([self]))
            return coordinator
        }
    }
}
