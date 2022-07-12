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
            return SignUpVM(useCase: r ~> (SignUpUseCase.self))
        }
        
        container.register(SignUpUseCase.self) { r in
            return SignUpUseCase(repo: r ~> (AuthController.self))
        }
        
        container.register(AuthController.self) { r in
            return AuthController(networkService: r ~> (NetworkServiceProtocol.self))
        }
        
        // MARK: - SetUserInfoVC
        container.register(SetUserInfoVC.self) { _ in
            let vc = SetUserInfoVC()
            return vc
        }
        
        container.register(AuthCoordinator.self) { _ in
            guard let nav = self.nav else { return AuthCoordinator() }
            return AuthCoordinator(nav: nav, assembler: Assembler([self]))
        }
    }
}
