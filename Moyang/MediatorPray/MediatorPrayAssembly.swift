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
            
            return vc
        }
        container.register(MediatorPrayMainVM.self) { r in
            MediatorPrayMainVM(useCase: (r ~> GroupUseCase.self))
        }
        
        
        // MARK: - NewGroupVC
        container.register(NewGroupVC.self) { r in
            let vc = NewGroupVC()
            vc.vm = (r ~> NewGroupVM.self)
            
            return vc
        }
        container.register(NewGroupVM.self) { r in
            NewGroupVM(useCase: (r ~> GroupUseCase.self))
        }
        
        // MARK: - GroupUseCase
        container.register(GroupRepo.self) { r in
            GroupController(networkService: r ~> (NetworkServiceProtocol.self))
        }
        
        container.register(GroupUseCase.self) { r in
            GroupUseCase(repo: r ~> (GroupRepo.self))
        }
        
        // MARK: - Coordinator
        container.register(MediatorPrayCoordinator.self) { _ in
            guard let nav = self.nav else { return MediatorPrayCoordinator() }
            let coordinator = MediatorPrayCoordinator(nav: nav, assembler: Assembler([self]))
            return coordinator
        }
    }
}
