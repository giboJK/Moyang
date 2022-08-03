//
//  GroupPrayAssembly.swift
//  Moyang
//
//  Created by 정김기보 on 2022/06/02.
//

import Swinject
import SwinjectAutoregistration
import Foundation
import UIKit

class GroupPrayAssembly: Assembly, BaseAssembly {
    var nav: UINavigationController?
    
    deinit { Log.i(self) }
    
    func assemble(container: Container) {
        container.register(GroupPrayVC.self) { r in
            let vc = GroupPrayVC()
            vc.vm = (r ~> GroupPrayVM.self)
            return vc
        }
        
        container.register(GroupPrayingVC.self) { (_, vm: GroupPrayingVM) in
            let vc = GroupPrayingVC()
            vc.vm = vm
            return vc
        }
        
        container.register(NetworkServiceProtocol.self) { _ in
            AFNetworkService(sessionConfiguration: .default)
        }
        
        // MARK: - GroupPray
        container.register(GroupPrayVM.self) { r in
            GroupPrayVM(useCase: (r ~> PrayUseCase.self))
        }
        
        // MARK: - GroupInfo
        container.register(GroupInfoVM.self) { _ in
            GroupInfoVM()
        }
        
        container.register(GroupInfoVC.self) { r in
            let vc = GroupInfoVC()
            vc.vm = r ~> (GroupInfoVM.self)
            return vc
        }
        
        // MARK: - NewPrayVC
        container.register(NewPrayVC.self) { r in
            let vc = NewPrayVC()
            vc.vm = r ~> (NewPrayVM.self)
            return vc
        }
        container.register(NewPrayVM.self) { r in
            return NewPrayVM(useCase: (r ~> PrayUseCase.self))
        }
        
        container.register(PrayUseCase.self) { r in
            return PrayUseCase(repo: (r ~> PrayRepo.self))
        }
        
        container.register(PrayRepo.self) { r in
            PrayController(networkService: r ~> (NetworkServiceProtocol.self))
        }
        
        container.register(PrayUseCase.self) { r in
            PrayUseCase(repo: r ~> (PrayRepo.self))
        }
        
        // MARK: - Coordinator
        container.register(GroupPrayCoordinator.self) { _ in
            guard let nav = self.nav else { return GroupPrayCoordinator() }
            let coordinator = GroupPrayCoordinator(nav: nav, assembler: Assembler([self]))
            return coordinator
        }
    }
}
