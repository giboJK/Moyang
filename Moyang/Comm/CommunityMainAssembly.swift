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
        container.register(CommunityMainVC.self) { r in
            let vc = CommunityMainVC()
            
            vc.vm = r ~> (CommunityMainVM.self)
            
            return vc
        }
        
        container.register(CommunityMainVM.self) { r in
            CommunityMainVM(useCase: r ~> (CommunityMainUseCase.self))
        }
        
        container.register(CommunityMainUseCase.self) { r in
            CommunityMainUseCase(repo: r ~> (CommunityMainRepo.self))
        }
        
//        container.register(CommunityMainRepo.self) { r in
//            CommunityController(networkService: r ~> (NetworkServiceProtocol.self))
//        }
        
        container.register(CommunityMainRepo.self) { r in
            CommunityController(firestoreService: r ~> (FirestoreService.self))
        }
        
        container.register(NetworkServiceProtocol.self) { _ in
            AFNetworkService(sessionConfiguration: .default)
        }
        
        container.register(FirestoreService.self) { _ in
            FSServiceImpl()
        }
        
        container.register(CommunityMainCoordinator.self) { _ in
            guard let nav = self.nav else { return CommunityMainCoordinator() }
            let coordinator = CommunityMainCoordinator(nav: nav, assembler: Assembler([self]))
            return coordinator
        }
        
        assembleGroupPray(container: container)
    }
    
    private func assembleGroupPray(container: Container) {
        container.register(GroupPrayVC.self) { (_, groupPrayVM: GroupPrayVM) in
            let vc = GroupPrayVC()
            vc.vm = groupPrayVM
            return vc
        }
    }
}
