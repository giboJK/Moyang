//
//  GroupPrayCoordinator.swift
//  Moyang
//
//  Created by 정김기보 on 2022/06/02.
//

import Foundation
import Swinject
import UIKit

class GroupPrayCoordinator: Coordinator {
    
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

extension GroupPrayCoordinator: GroupPrayVCDelegate {
    func didTapInfoButton() {
        
    }
    func didTapPray(vm: GroupPrayDetailVM) {
        if let vc = assembler.resolver.resolve(GroupPrayDetailVC.self, argument: vm) {
            nav.pushViewController(vc, animated: true)
            vc.coordinator = self
        }
    }
}

extension GroupPrayCoordinator: GroupPrayDetailVCDelegate {
    
}
