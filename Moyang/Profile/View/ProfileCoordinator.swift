//
//  ProfileCoordinator.swift
//  Moyang
//
//  Created by kibo on 2022/09/14.
//

import Foundation
import Swinject
import UIKit

class ProfileCoordinator: Coordinator {
    
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
        if let vc = assembler.resolver.resolve(ProfileVC.self) {
            nav.pushViewController(vc, animated: true)
            vc.coordinator = self
        } else {
            Log.e("error")
        }
    }
}


// MARK: - ProfileVCDelegate
extension ProfileCoordinator: ProfileVCDelegate {
    func didTapNoticeButton() {
        if let vc = assembler.resolver.resolve(NoticeListVC.self) {
            nav.pushViewController(vc, animated: true)
            vc.coordinator = self
        } else {
            Log.e("error")
        }
    }
    
    func didTapAlarmButton() {
        if let vc = assembler.resolver.resolve(AlarmSetVC.self) {
            nav.pushViewController(vc, animated: true)
            vc.coordinator = self
        } else {
            Log.e("error")
        }
    }
    
    func didTapLogoutButton() {
        UserData.shared.email = nil
        UserData.shared.password = nil
        nav.popViewController(animated: true)
        let vcList = nav.viewControllers
        if !vcList.contains(where: { $0 is IntroVC }) {
            NotificationCenter.default.post(name: NSNotification.Name("LOGOUT_SUCCESS"), object: nil, userInfo: nil)
        }
    }
}

// MARK: - NoticeListVCDelegate
extension ProfileCoordinator: NoticeListVCDelegate {
    func showNotice(vm: NoticeVM) {
        if let vc = assembler.resolver.resolve(NoticeVC.self) {
            vc.vm = vm
            nav.pushViewController(vc, animated: true)
        } else {
            Log.e("error")
        }
    }
}

// MARK: - AlarmSetVCDelegate
extension ProfileCoordinator: AlarmSetVCDelegate {
}
