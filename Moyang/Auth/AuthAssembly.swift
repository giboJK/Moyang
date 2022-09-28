//
//  AuthAssembly.swift
//  Moyang
//
//  Created by kibo on 2022/07/11.
//

import Swinject
import SwinjectAutoregistration
import Foundation
import UIKit

class AuthAssembly: Assembly, BaseAssembly {
    var nav: UINavigationController?
    
    deinit { Log.i(self) }
    
    func assemble(container: Container) {
        container.register(NetworkServiceProtocol.self) { _ in
            AFNetworkService(sessionConfiguration: .default)
        }
        
        // MARK: - TermsVC
        container.register(TermsVC.self) { _ in
            let vc = TermsVC()
            return vc
        }
        
        // MARK: - SignUpVC
        container.register(SignUpVC.self) { r in
            let vc = SignUpVC()
            vc.vm = r ~> (SignUpVM.self)
            return vc
        }
        
        container.register(SignUpVM.self) { r  in
            return SignUpVM(useCase: r ~> (AuthUseCase.self))
        }
        
        container.register(AuthUseCase.self) { r in
            return AuthUseCase(repo: r ~> (AuthController.self))
        }
        
        container.register(AuthController.self) { r in
            return AuthController(networkService: r ~> (NetworkServiceProtocol.self))
        }
        
        // MARK: - SetUserInfoVC
        container.register(SetUserInfoVC.self) { _ in
            let vc = SetUserInfoVC()
            return vc
        }
        
        // MARK: - LogInVC
        container.register(LogInVC.self) { r in
            let vc = LogInVC()
            vc.vm = r ~> (LogInVM.self)
            return vc
        }
        
        container.register(LogInVM.self) { r  in
            return LogInVM(useCase: r ~> (AuthUseCase.self))
        }
        
        // MARK: - Assembly & Coordinator
        container.register(MainAssembly.self) { _ in
            let assembly = MainAssembly()
            assembly.nav = self.nav
            return assembly
        }
        container.register(GroupActivityAssembly.self) { _ in
            let assembly = GroupActivityAssembly()
            assembly.nav = self.nav
            return assembly
        }
        container.register(TodayAssembly.self) { _ in
            let assembly = TodayAssembly()
            assembly.nav = self.nav
            return assembly
        }
        container.register(ProfileAssembly.self) { _ in
            let assembly = ProfileAssembly()
            assembly.nav = self.nav
            return assembly
        }
        
        container.register(AuthCoordinator.self) { r in
            guard let nav = self.nav else { return AuthCoordinator() }
            let main = r ~> (MainAssembly.self)
            let today = r ~> (TodayAssembly.self)
            let activity = r ~> (GroupActivityAssembly.self)
            let profile = r ~> (ProfileAssembly.self)
            return AuthCoordinator(nav: nav, assembler: Assembler([self,
                                                                   main,
                                                                   today,
                                                                   activity,
                                                                   profile]))
        }
    }
}
