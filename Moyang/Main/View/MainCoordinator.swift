//
//  MainCoordinator.swift
//  Moyang
//
//  Created by 정김기보 on 2022/05/26.
//

import Foundation
import Swinject
import UIKit

class MainCoordinator: Coordinator {
    
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
        if let vc = assembler.resolver.resolve(MainVC.self) {
            nav.pushViewController(vc, animated: animated)
            completion?()
        }
    }
}

extension MainCoordinator: AllGroupVCDelegate {
    func didTapGroup(vm: GroupActivityVM) {
        guard let groupPrayCoordinator = assembler.resolver.resolve(GroupActivityCoordinator.self) else {
            Log.e("Coordinator init failed")
            return
        }
        if let vc = assembler.resolver.resolve(GroupActivityVC.self, argument: vm) {
            nav.pushViewController(vc, animated: true)
            vc.coordinator = groupPrayCoordinator
            vc.groupCreateDate = vm.groupCreateDate.value ?? Date()
        }
    }
}
