//
//  GroupPrayAssembly.swift
//  Moyang
//
//  Created by 정김기보 on 2022/06/02.
//

import Swinject
import SwinjectAutoregistration
import Foundation
import UIKit

class GroupPrayAssembly: Assembly, BaseAssembly {
    var nav: UINavigationController?
    
    deinit { Log.i(self) }
    
    func assemble(container: Container) {
        container.register(GroupPrayVC.self) { (_, groupPrayVM: GroupPrayVM) in
            let vc = GroupPrayVC()
            vc.vm = groupPrayVM
            return vc
        }
        
        container.register(NewPrayVC.self) { (_, groupPrayVM: GroupPrayVM) in
            let vc = NewPrayVC()
            vc.vm = groupPrayVM
            return vc
        }
        
        container.register(GroupPrayListVC.self) { (_, vm: GroupPrayListVM) in
            let vc = GroupPrayListVC()
            vc.vm = vm
            return vc
        }
        
        container.register(GroupPrayingVC.self) { (_, vm: GroupPrayingVM) in
            let vc = GroupPrayingVC()
            vc.vm = vm
            return vc
        }
        
        container.register(GroupPrayCoordinator.self) { _ in
            guard let nav = self.nav else { return GroupPrayCoordinator() }
            let coordinator = GroupPrayCoordinator(nav: nav, assembler: Assembler([self]))
            return coordinator
        }
    }
}
