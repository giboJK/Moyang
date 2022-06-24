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
    
    func didTapNewPrayButton(vm: GroupPrayVM?) {
        guard let vm = vm else { return }

        if let vc = assembler.resolver.resolve(NewPrayVC.self, argument: vm) {
            nav.present(vc, animated: true)
        } else {
            Log.e("")
        }
    }
    
    func didTapPray(vm: GroupPrayListVM) {
        if let vc = assembler.resolver.resolve(GroupPrayListVC.self, argument: vm) {
            nav.pushViewController(vc, animated: true)
            vc.coordinator = self
        } else {
            Log.e("")
        }
    }
}

extension GroupPrayCoordinator: GroupPrayListVCDelegate {
    func didTapPraybutton(vm: GroupPrayingVM) {
        if let vc = assembler.resolver.resolve(GroupPrayingVC.self, argument: vm) {
            vc.modalPresentationStyle = .fullScreen
            nav.present(vc, animated: true)
            vc.coordinator = self
        } else {
            Log.e("")
        }
    }
}

extension GroupPrayCoordinator: GroupPrayingVCDelegate {
    
}
