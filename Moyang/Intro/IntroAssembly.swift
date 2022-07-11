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
        container.register(IntroVM.self) { _ in
            IntroVM()
        }
        
        // MARK: - Coordinator
        container.register(AuthAssembly.self) { _ in
            AuthAssembly()
        }
        
        container.register(IntroCoordinator.self) { r in
            guard let nav = self.nav else { return IntroCoordinator() }
            let authAssembly = r ~> (AuthAssembly.self)
            authAssembly.nav = nav
            return IntroCoordinator(nav: nav, assembler: Assembler([self,
                                                                    authAssembly]))
        }
    }
}
