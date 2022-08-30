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
            vc.coordinator = r ~> (GroupPrayCoordinator.self)
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
        
        // MARK: - GroupNews
        container.register(GroupNewsVM.self) { r in
            GroupNewsVM(groupUseCase: r ~> (GroupUseCase.self), prayUseCase: r ~> (PrayUseCase.self))
        }
        container.register(GroupNewsVC.self) { r in
            let vc = GroupNewsVC()
            vc.vm = r ~> (GroupNewsVM.self)
            return vc
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
        container.register(NewPrayVC.self) { (r, useCase: PrayUseCase) in
            let vc = NewPrayVC()
            vc.vm = r ~> (NewPrayVM.self, argument: useCase)
            return vc
        }
        container.register(NewPrayVM.self) { (_, useCase: PrayUseCase) in
            return NewPrayVM(useCase: useCase)
        }
        
        container.register(NewPrayVM.self) { r in
            return NewPrayVM(useCase: (r ~> PrayUseCase.self))
        }
        
        // MARK: - GroupPrayingVC
        container.register(GroupPrayingVC.self) { (r, useCase: PrayUseCase, groupID: String, userID: String, prayID: String) in
            let vc = GroupPrayingVC()
            let vm = r ~> (GroupPrayingVM.self, arguments: (useCase, groupID, userID))
            vm.prayID = prayID
            vc.vm = vm
            return vc
        }
        
        container.register(GroupPrayingVC.self) { (r, useCase: PrayUseCase, groupID: String) in
            let vc = GroupPrayingVC()
            vc.vm = r ~> (GroupPrayingVM.self, arguments: (useCase, groupID))
            return vc
        }
        
        container.register(GroupPrayingVM.self) { (_, useCase: PrayUseCase, groupID: String, userID: String) in
            return GroupPrayingVM(useCase: useCase, groupID: groupID, userID: userID)
        }
        container.register(GroupPrayingVM.self) { (_, useCase: PrayUseCase, groupID: String) in
            return GroupPrayingVM(useCase: useCase, groupID: groupID)
        }
        
        // MARK: - PrayUseCase
        container.register(PrayRepo.self) { r in
            PrayController(networkService: r ~> (NetworkServiceProtocol.self))
        }
        
        container.register(PrayUseCase.self) { r in
            PrayUseCase(repo: r ~> (PrayRepo.self))
        }
        
        // MARK: - GroupUseCase
        container.register(GroupRepo.self) { r in
            GroupController(networkService: r ~> (NetworkServiceProtocol.self))
        }
        
        container.register(GroupUseCase.self) { r in
            GroupUseCase(repo: r ~> (GroupRepo.self))
        }
        
        // MARK: - Coordinator
        container.register(GroupPrayCoordinator.self) { _ in
            guard let nav = self.nav else { return GroupPrayCoordinator() }
            let coordinator = GroupPrayCoordinator(nav: nav, assembler: Assembler([self]))
            return coordinator
        }
    }
}
