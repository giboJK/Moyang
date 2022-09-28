//
//  ProfileAssembly.swift
//  Moyang
//
//  Created by 정김기보 on 2022/09/28.
//


import Swinject
import SwinjectAutoregistration
import Foundation
import UIKit

class ProfileAssembly: Assembly, BaseAssembly {
    var nav: UINavigationController?
    
    deinit { Log.i(self) }
    
    func assemble(container: Container) {
        container.register(NetworkServiceProtocol.self) { _ in
            AFNetworkService(sessionConfiguration: .default)
        }
        
        // MARK: - Profile
        container.register(ProfileVC.self) { r in
            let vc = ProfileVC()
            vc.vm = (r ~> ProfileVM.self)
            vc.coordinator = r ~> (ProfileCoordinator.self)
            return vc
        }
        
        container.register(ProfileVM.self) { _ in
            ProfileVM()
        }
        
        // MARK: - AlarmSet
        container.register(AlarmSetVC.self) { r in
            let vc = AlarmSetVC()
            vc.vm = r ~> (AlarmSetVM.self)
            return vc
        }
        
        container.register(AlarmSetVM.self) { _ in
            AlarmSetVM()
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
        container.register(ProfileCoordinator.self) { _ in
            guard let nav = self.nav else { return ProfileCoordinator() }
            let coordinator = ProfileCoordinator(nav: nav, assembler: Assembler([self]))
            return coordinator
        }
    }
}

