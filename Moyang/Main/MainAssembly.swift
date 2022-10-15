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
            vc.groupActivityVC = r ~> (GroupActivityVC.self)
            vc.profileVC = r ~> (ProfileVC.self)
            
            return vc
        }
        container.register(NetworkServiceProtocol.self) { _ in
            AFNetworkService(sessionConfiguration: .default)
        }
                
        container.register(PrayRepo.self) { r in
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
        
        container.register(GroupActivityAssembly.self) { _ in
            let assembly = GroupActivityAssembly()
            assembly.nav = self.nav
            return assembly
        }
        container.register(ProfileAssembly.self) { _ in
            let assembly = ProfileAssembly()
            assembly.nav = self.nav
            return assembly
        }
        container.register(WorshipNoteAssembly.self) { _ in
            let assembly = WorshipNoteAssembly()
            assembly.nav = self.nav
            return assembly
        }
        container.register(BibleAssembly.self) { _ in
            let assembly = BibleAssembly()
            assembly.nav = self.nav
            return assembly
        }
        
        container.register(MainCoordinator.self) { r in
            guard let nav = self.nav else { return MainCoordinator() }
            let today = r ~> (TodayAssembly.self)
            let activity = r ~> (GroupActivityAssembly.self)
            let profile = r ~> (ProfileAssembly.self)
            let note = r ~> (WorshipNoteAssembly.self)
            let bible = r ~> (BibleAssembly.self)
            let assembler = Assembler([self, today, activity, profile, note, bible])
            let coordinator = MainCoordinator(nav: nav, assembler: assembler)
            return coordinator
        }
    }
}
