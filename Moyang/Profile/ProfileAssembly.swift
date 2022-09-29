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
        
        container.register(AlarmRepo.self) { r in
            ProfileController(networkService: r ~> (NetworkServiceProtocol.self))
        }
        
        container.register(AlarmUseCase.self) { r in
            AlarmUseCase(repo: r ~> (AlarmRepo.self))
        }
        
        container.register(AlarmSetVM.self) { r in
            AlarmSetVM(useCase: r ~> (AlarmUseCase.self))
        }
        
        // MARK: - Coordinator
        container.register(ProfileCoordinator.self) { _ in
            guard let nav = self.nav else { return ProfileCoordinator() }
            let coordinator = ProfileCoordinator(nav: nav, assembler: Assembler([self]))
            return coordinator
        }
    }
}
