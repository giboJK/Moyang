//
//  ActivityAssembly.swift
//  Moyang
//
//  Created by 정김기보 on 2022/06/02.
//

import Swinject
import SwinjectAutoregistration
import Foundation
import UIKit

class ActivityAssembly: Assembly, BaseAssembly {
    var nav: UINavigationController?
    
    deinit { Log.i(self) }
    
    func assemble(container: Container) {
        container.register(ActivityVC.self) { r in
            let vc = ActivityVC()
            vc.vm = (r ~> ActivityVM.self)
            vc.coordinator = r ~> (ActivityCoordinator.self)
            
            // View controllers
            let mediatorPrayMainVC = r ~> (MediatorPrayMainVC.self)
            mediatorPrayMainVC.coordinator = r ~> (MediatorPrayCoordinator.self)
            vc.mediatorPrayMainVC = mediatorPrayMainVC
            
            let myPrayMainVC = r ~> (MyPrayMainVC.self)
            myPrayMainVC.coordinator = r ~> (MyPrayCoordinator.self)
            vc.myPrayMainVC = myPrayMainVC
            
//            let noteMainVC = r ~> (NoteMainVC.self)
//            noteMainVC.coordinator = r ~> (WorshipNoteCoordinator.self)
//            vc.noteMainVC = noteMainVC
            return vc
        }
        
        
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
        
        // MARK: - GroupPray
        container.register(ActivityVM.self) { r in
            ActivityVM()
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
        
        
        // MARK: - Assembly
        container.register(MyPrayAssembly.self) { _ in
            let assembly = MyPrayAssembly()
            assembly.nav = self.nav
            return assembly
        }
        container.register(MediatorPrayAssembly.self) { _ in
            let assembly = MediatorPrayAssembly()
            assembly.nav = self.nav
            return assembly
        }
        
        // MARK: - Coordinator
        container.register(ActivityCoordinator.self) { r in
            guard let nav = self.nav else { return ActivityCoordinator() }
            let myPray = r ~> (MyPrayAssembly.self)
            let mediatorPray = r ~> (MediatorPrayAssembly.self)
            let assembler = Assembler([self, myPray, mediatorPray])
            let coordinator = ActivityCoordinator(nav: nav, assembler: assembler)
            return coordinator
        }
    }
}
