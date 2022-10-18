//
//  MyPrayAssembly.swift
//  Moyang
//
//  Created by 정김기보 on 2022/10/18.
//

import Swinject
import SwinjectAutoregistration
import Foundation
import UIKit

class MyPrayAssembly: Assembly, BaseAssembly {
    var nav: UINavigationController?
    
    deinit { Log.i(self) }
    
    func assemble(container: Container) {
        container.register(NetworkServiceProtocol.self) { _ in
            AFNetworkService(sessionConfiguration: .default)
        }
        
        // MARK: - MyPrayMain
        
        container.register(MyPrayMainVC.self) { r in
            let vc = MyPrayMainVC()
            vc.vm = (r ~> MyPrayMainVM.self)
            vc.coordinator = r ~> (MyPrayCoordinator.self)
            
            // View controllers
            
            return vc
        }
        container.register(MyPrayMainVM.self) { r in
            MyPrayMainVM(useCase: r ~> (MyPrayUseCase.self))
        }
        
        
        // MARK: - MyPray
        container.register(MyPrayRepo.self) { r in
            PrayController(networkService: r ~> (NetworkServiceProtocol.self))
        }
        
        container.register(MyPrayUseCase.self) { r in
            MyPrayUseCase(repo: r ~> (MyPrayRepo.self))
        }
        
        // MARK: - Coordinator
        container.register(MyPrayCoordinator.self) { _ in
            guard let nav = self.nav else { return MyPrayCoordinator() }
            let coordinator = MyPrayCoordinator(nav: nav, assembler: Assembler([self]))
            return coordinator
        }
    }
}
