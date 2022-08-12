//
//  TodayAssembly.swift
//  Moyang
//
//  Created by kibo on 2022/08/12.
//

import Swinject
import SwinjectAutoregistration
import Foundation
import UIKit

class TodayAssembly: Assembly, BaseAssembly {
    var nav: UINavigationController?
    
    deinit { Log.i(self) }
    
    func assemble(container: Container) {
        container.register(TaskDetailVC.self) { (r, vm: TaskDetailVM) in
            let vc = TaskDetailVC()
            vc.vm = vm
            return vc
        }
        
        container.register(TodayCoordinator.self) { _ in
            guard let nav = self.nav else { return TodayCoordinator() }
            let coordinator = TodayCoordinator(nav: nav, assembler: Assembler([self]))
            return coordinator
        }
    }
}
