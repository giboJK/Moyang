//
//  IntroAssembly.swift
//  Moyang
//
//  Created by 정김기보 on 2022/07/11.
//

import Swinject
import SwinjectAutoregistration
import Foundation
import UIKit

class IntroAssembly: Assembly, BaseAssembly {
    var nav: UINavigationController?
    
    deinit { Log.i(self) }
    
    func assemble(container: Container) {
        container.register(NetworkServiceProtocol.self) { _ in
            AFNetworkService(sessionConfiguration: .default)
        }
        
        // MARK: - IntroVC
        container.register(IntroVC.self) { r in
            let vc = IntroVC()
            vc.vm = r ~> (IntroVM.self)
            return vc
        }
        container.register(IntroVM.self) { r in
            IntroVM(useCase: r ~> (AuthUseCase.self))
        }
        
        container.register(AuthUseCase.self) { r in
            return AuthUseCase(repo: r ~> (AuthController.self))
        }
        container.register(AuthController.self) { r in
            return AuthController(networkService: r ~> (NetworkServiceProtocol.self))
        }
        
        // MARK: - Assembly & Coordinator
        container.register(MainAssembly.self) { _ in
            let assembly = MainAssembly()
            assembly.nav = self.nav
            return assembly
        }
        
        container.register(AuthAssembly.self) { _ in
            let assembly = AuthAssembly()
            assembly.nav = self.nav
            return assembly
        }
        container.register(IntroCoordinator.self) { r in
            guard let nav = self.nav else { return IntroCoordinator() }
            let auth = r ~> (AuthAssembly.self)
            let main = r ~> (MainAssembly.self)
            return IntroCoordinator(nav: nav, assembler: Assembler([self,
                                                                    auth,
                                                                    main]))
        }
    }
}
