//
//  MainAssembly.swift
//  Moyang
//
//  Created by 정김기보 on 2022/05/26.
//

import Swinject
import SwinjectAutoregistration
import Foundation
import UIKit

class MainAssembly: Assembly, BaseAssembly {
    var nav: UINavigationController?
    
    deinit { Log.i(self) }
    
    func assemble(container: Container) {
        container.register(MainVC.self) { r in
            let vc = MainVC()
            
            vc.todayVC = r ~> (TodayVC.self)
            vc.activityVC = r ~> (ActivityVC.self)
            vc.profileVC = r ~> (ProfileVC.self)
            
            return vc
        }
        container.register(NetworkServiceProtocol.self) { _ in
            AFNetworkService(sessionConfiguration: .default)
        }
                
        container.register(MyPrayRepo.self) { r in
            PrayController(networkService: r ~> (NetworkServiceProtocol.self))
        }
        
        container.register(NetworkServiceProtocol.self) { _ in
            AFNetworkService(sessionConfiguration: .default)
        }
        
        // MARK: - Assembly
        container.register(TodayAssembly.self) { _ in
            let assembly = TodayAssembly()
            assembly.nav = self.nav
            return assembly
        }
        
        container.register(ActivityAssembly.self) { _ in
            let assembly = ActivityAssembly()
            assembly.nav = self.nav
            return assembly
        }
        container.register(ProfileAssembly.self) { _ in
            let assembly = ProfileAssembly()
            assembly.nav = self.nav
            return assembly
        }
        container.register(BibleAssembly.self) { _ in
            let assembly = BibleAssembly()
            assembly.nav = self.nav
            return assembly
        }
        container.register(MyPrayAssembly.self) { _ in
            let assembly = MyPrayAssembly()
            assembly.nav = self.nav
            return assembly
        }
        container.register(MediatorPrayAssembly.self) { _ in
            let assembly = MediatorPrayAssembly()
            assembly.nav = self.nav
            return assembly
        }
        
        container.register(MainCoordinator.self) { r in
            guard let nav = self.nav else { return MainCoordinator() }
            let today = r ~> (TodayAssembly.self)
            let activity = r ~> (ActivityAssembly.self)
            let profile = r ~> (ProfileAssembly.self)
            let bible = r ~> (BibleAssembly.self)
            let myPray = r ~> (MyPrayAssembly.self)
            let mediatorPray = r ~> (MediatorPrayAssembly.self)
            let assembler = Assembler([self, today, activity, profile, bible, myPray, mediatorPray])
            let coordinator = MainCoordinator(nav: nav, assembler: assembler)
            return coordinator
        }
    }
}
