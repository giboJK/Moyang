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
    func didTapAlarmButton() {
        if let vc = assembler.resolver.resolve(AlarmSetVC.self) {
            nav.pushViewController(vc, animated: true)
            vc.coordinator = self
        } else {
            Log.e("error")
        }
    }
}

// MARK: - AlarmSetVCDelegate
extension ProfileCoordinator: AlarmSetVCDelegate {
}
