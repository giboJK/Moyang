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
        
        container.register(ProfileVM.self) { r in
            ProfileVM(useCase: r ~> (ProfileUseCase.self))
        }
        
        container.register(ProfileUseCase.self) { r in
            return ProfileUseCase(repo: r ~> (AuthController.self))
        }
        
        container.register(AuthController.self) { r in
            return AuthController(networkService: r ~> (NetworkServiceProtocol.self))
        }
        
        // MARK: - NoticeList
        container.register(NoticeListVC.self) { r in
            let vc = NoticeListVC()
            vc.vm = r ~> (NoticeVM.self)
            return vc
        }
        
        container.register(NoticeRepo.self) { r in
            ProfileController(networkService: r ~> (NetworkServiceProtocol.self))
        }
        
        container.register(NoticeUseCase.self) { r in
            NoticeUseCase(repo: r ~> (NoticeRepo.self))
        }
        
        container.register(NoticeVM.self) { r in
            NoticeVM(useCase: r ~> (NoticeUseCase.self))
        }
        
        // MARK: - Notice
        container.register(NoticeVC.self) { _ in
            NoticeVC()
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
