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
        
        
        // MARK: - GroupSearchVC
        container.register(GroupSearchVC.self) { r in
            let vc = GroupSearchVC()
            vc.vm = (r ~> GroupSearchVM.self)
            
            return vc
        }
        container.register(GroupSearchVM.self) { r in
            GroupSearchVM(useCase: (r ~> GroupUseCase.self))
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
        
        // MARK: - GroupDetailVC
        container.register(GroupDetailVC.self) { (_, vm: GroupDetailVM) in
            let vc = GroupDetailVC()
            vc.vm = vm
            
            return vc
        }
        
        
        // MARK: - GroupDetailMoreVC
        container.register(GroupDetailMoreVC.self) { (_, vm: GroupDetailVM) in
            let vc = GroupDetailMoreVC()
            vc.vm = vm
            
            return vc
        }
        
        // MARK: - GroupMemberPrayListVC
        container.register(GroupMemberPrayListVC.self) { (_, vm: GroupMemberPrayListVM) in
            let vc = GroupMemberPrayListVC()
            vc.vm = vm
            
            return vc
        }
        
        // MARK: - GroupMemberPrayDetailVC
        container.register(GroupMemberPrayDetailVC.self) { (_, vm: GroupMemberPrayDetailVM) in
            let vc = GroupMemberPrayDetailVC()
            vc.vm = vm
            
            return vc
        }
        
        // MARK: - GroupUseCase
        container.register(GroupRepo.self) { r in
            GroupController(networkService: r ~> (NetworkServiceProtocol.self))
        }
        
        container.register(MyPrayRepo.self) { r in
            PrayController(networkService: r ~> (NetworkServiceProtocol.self))
        }
        
        container.register(GroupUseCase.self) { r in
            GroupUseCase(repo: r ~> (GroupRepo.self), prayRepo: r ~> (MyPrayRepo.self))
        }
        
        // MARK: - Coordinator
        container.register(MediatorPrayCoordinator.self) { _ in
            guard let nav = self.nav else { return MediatorPrayCoordinator() }
            let coordinator = MediatorPrayCoordinator(nav: nav, assembler: Assembler([self]))
            return coordinator
        }
    }
}
