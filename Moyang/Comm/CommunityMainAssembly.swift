//
//  CommunityMainAssembly.swift
//  Moyang
//
//  Created by 정김기보 on 2022/05/26.
//

import Swinject
import SwinjectAutoregistration
import Foundation
import UIKit

class CommunityMainAssembly: Assembly, BaseAssembly {
    var nav: UINavigationController?
    
    deinit { Log.i(self) }
    
    func assemble(container: Container) {
        container.register(MainVC.self) { r in
            let vc = MainVC()
            
            vc.todayVC = r ~> (TodayVC.self)
            vc.communityMainVC = r ~> (CommunityMainVC.self)
            
            return vc
        }
        
        // MARK: - Today
        container.register(TodayVC.self) { r in
            let vc = TodayVC()
            
            vc.vm = r ~> (TodayVM.self)
            vc.coordinator = r ~> (TodayCoordinator.self)
            
            return vc
        }
        
        container.register(TodayVM.self) { _ in
            TodayVM()
        }
        
        // MARK: - CommunityMain
        container.register(CommunityMainVC.self) { r in
            let vc = CommunityMainVC()
            
            vc.vm = r ~> (CommunityMainVM.self)
            vc.coordinator = r ~> (CommunityMainCoordinator.self)
            
            return vc
        }
        
        container.register(CommunityMainVM.self) { r in
            CommunityMainVM(useCase: r ~> (CommunityMainUseCase.self))
        }
        
        container.register(CommunityMainUseCase.self) { r in
            CommunityMainUseCase(repo: r ~> (CommunityMainRepo.self))
        }
        
        container.register(NetworkServiceProtocol.self) { _ in
            AFNetworkService(sessionConfiguration: .default)
        }
        
        container.register(CommunityMainRepo.self) { r in
            CommunityController(networkService: r ~> (NetworkServiceProtocol.self))
        }
        
        container.register(PrayRepo.self) { r in
            PrayController(networkService: r ~> (NetworkServiceProtocol.self))
        }
        
        container.register(NetworkServiceProtocol.self) { _ in
            AFNetworkService(sessionConfiguration: .default)
        }
        
        // MARK: - AllGroup
        container.register(AllGroupRepo.self) { r in
            CommunityController(networkService: r ~> (NetworkServiceProtocol.self))
        }
        
        container.register(AllGroupUseCase.self) { r in
            AllGroupUseCase(repo: r ~> (AllGroupRepo.self))
        }
        
        container.register(AllGroupVM.self) { r in
            AllGroupVM(useCase: r ~> (AllGroupUseCase.self), communityUseCase: r ~> (CommunityMainUseCase.self))
        }
        
        container.register(AllGroupVC.self) { r in
            let vc = AllGroupVC()
            vc.vm = r ~> (AllGroupVM.self)
            return vc
        }
        
        // MARK: - Assembly
        container.register(TodayAssembly.self) { _ in
            let assembly = TodayAssembly()
            assembly.nav = self.nav
            return assembly
        }
        
        container.register(GroupPrayAssembly.self) { _ in
            let assembly = GroupPrayAssembly()
            assembly.nav = self.nav
            return assembly
        }
        
        
        // MARK: - Coordinator
        container.register(TodayCoordinator.self) { r in
            guard let nav = self.nav else { return TodayCoordinator() }
            let coordinator = TodayCoordinator(nav: nav,
                                               assembler: Assembler([self,
                                                                     r ~> (TodayAssembly.self)]))
            return coordinator
        }
        
        container.register(CommunityMainCoordinator.self) { r in
            guard let nav = self.nav else { return CommunityMainCoordinator() }
            let coordinator = CommunityMainCoordinator(nav: nav,
                                                       assembler: Assembler([self,
                                                                             r ~> (GroupPrayAssembly.self)]))
            return coordinator
        }
    }
}
