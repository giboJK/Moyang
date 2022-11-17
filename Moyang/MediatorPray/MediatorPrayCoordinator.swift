//
//  MediatorPrayCoordinator.swift
//  Moyang
//
//  Created by kibo on 2022/10/24.
//

import Foundation
import Swinject
import UIKit

class MediatorPrayCoordinator: Coordinator {
    
    var assembler: Assembler
    var nav: UINavigationController
    
    required init(nav: UINavigationController, assembler: Assembler) {
        self.nav = nav
        self.assembler = assembler
    }
    
    required init() {
        nav = UINavigationController()
        assembler = Assembler([])
        Log.e("Coordinator init failed.")
    }
    
    func start(_ animated: Bool, completion: (() -> Void)?) {
        // Do nothing
    }
}

extension MediatorPrayCoordinator: MediatorPrayMainVCDelegate {
    func didTapGroup(vm: GroupDetailVM) {
        if let vc = assembler.resolver.resolve(GroupDetailVC.self, argument: vm) {
            vc.coordinator = self
            nav.pushViewController(vc, animated: true)
        } else {
            Log.e("error")
        }
    }
    
    func didTapNewGroupView() {
        if let vc = assembler.resolver.resolve(NewGroupVC.self) {
            vc.coordinator = self
            nav.pushViewController(vc, animated: true)
        } else {
            Log.e("error")
        }
    }
}

extension MediatorPrayCoordinator: NewGroupVCDelegate {
    
}

extension MediatorPrayCoordinator: GroupDetailVCDelegate {
    
}
