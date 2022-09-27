//
//  GroupActivityCoordinator.swift
//  Moyang
//
//  Created by 정김기보 on 2022/06/02.
//

import Foundation
import Swinject
import UIKit

class GroupActivityCoordinator: Coordinator {
    
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
        if let vc = assembler.resolver.resolve(GroupActivityVC.self) {
            nav.pushViewController(vc, animated: true)
            vc.coordinator = self
            vc.groupCreateDate = groupInfo.createDate.isoToDate()
        } else {
            Log.e("error")
        }
    }
}

extension GroupActivityCoordinator: GroupActivityVCDelegate {
    
    func didTapNewsButton() {
        if let vc = assembler.resolver.resolve(GroupEventVC.self) {
            nav.pushViewController(vc, animated: true)
            nav.isNavigationBarHidden = false
            nav.navigationBar.backItem?.title = ""
        } else {
            Log.e("")
        }
    }
    
    func didTapNewPrayButton(vm: GroupActivityVM) {
        if let vc = assembler.resolver.resolve(NewPrayVC.self, argument: vm.useCase) {
            nav.present(vc, animated: true)
        } else {
            Log.e("")
        }
    }
    func didTapNewQTButton() {
        if let vc = assembler.resolver.resolve(NewQTVC.self) {
            nav.present(vc, animated: true)
        } else {
            Log.e("")
        }
    }
    
    
    func didTapPrayButton(vm: GroupActivityVM) {
        guard let groupID = UserData.shared.groupID else { Log.e("No group"); return }
        if let vc = assembler.resolver.resolve(GroupPrayingVC.self, arguments: vm.useCase, groupID) {
            nav.pushViewController(vc, animated: true)
        } else {
            Log.e("")
        }
    }
    
    func didTapPray(vm: GroupPrayDetailVM) {
        let vc = GroupPrayDetailVC()
        vc.vm = vm
        vc.coordinator = self
        nav.pushViewController(vc, animated: true)
        nav.isNavigationBarHidden = false
        nav.navigationBar.backItem?.title = ""
    }
}

extension GroupActivityCoordinator: GroupPrayDetailVCDelegate {
    func didTapPrayButton(vm: GroupPrayDetailVM) {
        guard let groupID = UserData.shared.groupID else { Log.e("No group"); return }
        if let vc = assembler.resolver.resolve(GroupPrayingVC.self,
                                               arguments: vm.useCase, groupID, vm.userID, vm.prayID) {
            nav.pushViewController(vc, animated: true)
        } else {
            Log.e("")
        }
    }
}

extension GroupActivityCoordinator: GroupPrayingVCDelegate {
    
}