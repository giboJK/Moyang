//
//  MyPrayCoordinator.swift
//  Moyang
//
//  Created by 정김기보 on 2022/10/18.
//

import Foundation
import Swinject
import UIKit

class MyPrayCoordinator: Coordinator {
    
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

extension MyPrayCoordinator: MyPrayMainVCDelegate {
    func didTapNewPray() {
        if let vc = assembler.resolver.resolve(NewPrayVC.self) {
            vc.coordinator = self
            nav.pushViewController(vc, animated: true)
        } else {
            Log.e("")
        }
    }
    
    func didTapPrayList() {
        if let vc = assembler.resolver.resolve(MyPrayListVC.self) {
            vc.coordinator = self
            nav.pushViewController(vc, animated: true)
        } else {
            Log.e("")
        }
    }
    
    func didTapPray(vm: MyPrayDetailVM) {
        if let topVC = nav.topViewController, topVC is MainVC {
            if let vc = assembler.resolver.resolve(MyPrayDetailVC.self) {
                vc.vm = vm
                vc.coordinator = self
                nav.pushViewController(vc, animated: true)
            } else {
                Log.e("")
            }
        }
    }
    
    func didTapSetAlarm() {
        if let vc = assembler.resolver.resolve(NewAlarmVC.self) {
            nav.topViewController?.present(vc, animated: true)
        } else {
            Log.e("error")
        }
    }
}

// MARK: - MyPrayDetailVCDelegate
extension MyPrayCoordinator: MyPrayDetailVCDelegate {
    func didTapMoreButton(vm: MyPrayDetailVM) {
        if let vc = assembler.resolver.resolve(MyPrayDetailEditVC.self, argument: vm) {
            nav.pushViewController(vc, animated: true)
        } else {
            Log.e("error")
        }
    }
    
    func didTapPrayButton(vm: GroupPrayingVM) {
        
    }
}

// MARK: - MyPrayListVCDelegate
extension MyPrayCoordinator: MyPrayListVCDelegate {
    
}


// MARK: - AlarmSetVCDelegate
extension MyPrayCoordinator: AlarmSetVCDelegate {
}


// MARK: - NewPrayVCDelegate
extension MyPrayCoordinator: NewPrayVCDelegate {
    func didTapPray(vm: MyPrayPrayingVM) {
        if let vc = assembler.resolver.resolve(MyPrayPrayingVC.self) {
            vc.vm = vm
            nav.pushViewController(vc, animated: true)
            
            var vcList = self.nav.viewControllers
            vcList.removeAll(where: { $0 is NewPrayVC })
            self.nav.viewControllers = vcList
        } else {
            Log.e("error")
        }
    }
}
