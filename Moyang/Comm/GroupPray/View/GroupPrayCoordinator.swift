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
        guard let groupInfo = UserData.shared.groupInfo else { Log.e("No group"); return }
        if let vc = assembler.resolver.resolve(GroupPrayVC.self) {
            nav.pushViewController(vc, animated: true)
            vc.coordinator = self
            vc.groupCreateDate = groupInfo.createDate.isoToDate()
        } else {
            Log.e("error")
        }
    }
}

extension GroupPrayCoordinator: GroupPrayVCDelegate {
    func didTapInfoButton() {
        if let vc = assembler.resolver.resolve(GroupInfoVC.self) {
            nav.pushViewController(vc, animated: true)
        } else {
            Log.e("")
        }
    }
    
    func didTapNewPrayButton() {
        if let vc = assembler.resolver.resolve(NewPrayVC.self) {
            nav.present(vc, animated: true)
        } else {
            Log.e("")
        }
    }
    
    func didTapPray() {
    }
}

extension GroupPrayCoordinator: GroupPrayingVCDelegate {
    
}
