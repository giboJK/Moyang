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
        container.register(SignUpVC.self) { r in
            let vc = SignUpVC()

            vc.vm = r ~> (APISignUpVM.self)
            
            return vc
        }
        
        container.register(NetworkServiceProtocol.self) { _ in
            AFNetworkService(sessionConfiguration: .default)
        }
        
        container.register(APISignUpVM.self) { _  in
            return APISignUpVM()
        }
        
        container.register(AuthCoordinator.self) { r in
            guard let nav = self.nav else { return AuthCoordinator() }
            return AuthCoordinator(nav: nav, assembler: Assembler([self]))
        }
    }
}
