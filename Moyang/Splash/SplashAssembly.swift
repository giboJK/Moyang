//
//  SplashAssembly.swift
//  Moyang
//
//  Created by 정김기보 on 2022/08/27.
//

import Swinject
import SwinjectAutoregistration
import Foundation
import UIKit

class SplashAssembly: Assembly, BaseAssembly {
    var nav: UINavigationController?
    
    deinit { Log.i(self) }
    
    func assemble(container: Container) {
        container.register(NetworkServiceProtocol.self) { _ in
            AFNetworkService(sessionConfiguration: .default)
        }
        
        // MARK: - SplashVC
        container.register(SplashVC.self) { r in
            let vc = SplashVC()
            vc.vm = r ~> (SplashVM.self)
            return vc
        }
        container.register(SplashVM.self) { r in
            SplashVM(useCase: r ~> (AuthUseCase.self))
        }
        
        container.register(AuthUseCase.self) { r in
            return AuthUseCase(repo: r ~> (AuthController.self))
        }
        container.register(AuthController.self) { r in
            return AuthController(networkService: r ~> (NetworkServiceProtocol.self))
        }
        
        // MARK: - Assembly & Coordinator
        container.register(IntroAssembly.self) { _ in
            let assembly = IntroAssembly()
            assembly.nav = self.nav
            return assembly
        }
        container.register(MainAssembly.self) { _ in
            let assembly = MainAssembly()
            assembly.nav = self.nav
            return assembly
        }
        
        container.register(SplashCoordinator.self) { r in
            guard let nav = self.nav else { return SplashCoordinator() }
            let intro = r ~> (IntroAssembly.self)
            let main = r ~> (MainAssembly.self)
            return SplashCoordinator(nav: nav, assembler: Assembler([self,
                                                                     intro, main]))
        }
    }
}
