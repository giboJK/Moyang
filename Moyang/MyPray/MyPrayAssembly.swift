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
            
            return vc
        }
        container.register(MyPrayMainVM.self) { r in
            MyPrayMainVM(useCase: r ~> (MyPrayUseCase.self), alarmUseCase: r ~> (AlarmUseCase.self))
        }
        
        
        // MARK: - NewPrayVC
        container.register(NewPrayVC.self) { r in
            let vc = NewPrayVC()
            vc.vm = r ~> (NewPrayVM.self)
            return vc
        }
        
        container.register(NewPrayVM.self) { r in
            return NewPrayVM(useCase: (r ~> MyPrayUseCase.self))
        }
        
        
        // MARK: - MyPrayDetailVC
        container.register(MyPrayDetailVC.self) { _ in
            let vc = MyPrayDetailVC()
            return vc
        }
        
        // MARK: - MyPrayDetailEditVC
        container.register(MyPrayDetailEditVC.self) { (_, vm: MyPrayDetailVM) in
            let vc = MyPrayDetailEditVC()
            vc.vm = vm
            return vc
        }
        
        
        // MARK: - MyPrayListVC
        container.register(MyPrayListVC.self) { r in
            let vc = MyPrayListVC()
            vc.vm = r ~> (MyPrayListVM.self)
            return vc
        }
        
        container.register(MyPrayListVM.self) { r in
            return MyPrayListVM(useCase: (r ~> MyPrayUseCase.self))
        }
        
        
        // MARK: - MyPrayPrayingVC
        container.register(MyPrayPrayingVC.self) { _ in
            MyPrayPrayingVC()
        }
        
        
        // MARK: - NewAlarmVC
        container.register(NewAlarmVC.self) { r in
            let vc = NewAlarmVC()
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
        
        
        // MARK: - MyPrayRepo
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
