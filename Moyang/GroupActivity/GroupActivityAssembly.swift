//
//  GroupActivityAssembly.swift
//  Moyang
//
//  Created by 정김기보 on 2022/06/02.
//

import Swinject
import SwinjectAutoregistration
import Foundation
import UIKit

class GroupActivityAssembly: Assembly, BaseAssembly {
    var nav: UINavigationController?
    
    deinit { Log.i(self) }
    
    func assemble(container: Container) {
        container.register(GroupActivityVC.self) { r in
            let vc = GroupActivityVC()
            vc.vm = (r ~> GroupActivityVM.self)
            vc.coordinator = r ~> (GroupActivityCoordinator.self)
            
            // View controllers
            let mediatorPrayMainVC = r ~> (MediatorPrayMainVC.self)
            mediatorPrayMainVC.coordinator = r ~> (MediatorPrayCoordinator.self)
            vc.mediatorPrayMainVC = mediatorPrayMainVC
            
            let myPrayMainVC = r ~> (MyPrayMainVC.self)
            myPrayMainVC.coordinator = r ~> (MyPrayCoordinator.self)
            vc.myPrayMainVC = myPrayMainVC
            
            let noteMainVC = r ~> (NoteMainVC.self)
            noteMainVC.coordinator = r ~> (WorshipNoteCoordinator.self)
            vc.noteMainVC = noteMainVC
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
        container.register(GroupActivityVM.self) { r in
            GroupActivityVM()
        }
        
        // MARK: - GroupNews
        container.register(GroupEventVM.self) { r in
            GroupEventVM(groupUseCase: r ~> (GroupUseCase.self), prayUseCase: r ~> (MyPrayUseCase.self))
        }
        container.register(GroupEventVC.self) { r in
            let vc = GroupEventVC()
            vc.vm = r ~> (GroupEventVM.self)
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
        
        // MARK: - GroupUseCase
        container.register(GroupRepo.self) { r in
            GroupController(networkService: r ~> (NetworkServiceProtocol.self))
        }
        
        container.register(GroupUseCase.self) { r in
            GroupUseCase(repo: r ~> (GroupRepo.self))
        }
        
        // MARK: - Assembly
        
        // MARK: - Coordinator
        container.register(GroupActivityCoordinator.self) { r in
            guard let nav = self.nav else { return GroupActivityCoordinator() }
            let coordinator = GroupActivityCoordinator(nav: nav, assembler: Assembler([self]))
            return coordinator
        }
    }
}
