//
//  AuthCoordinator.swift
//  Moyang
//
//  Created by kibo on 2022/07/11.
//

import Foundation
import Swinject
import UIKit

class AuthCoordinator: Coordinator {
    var assembler: Assembler
    
    var nav: UINavigationController
    
    required init(nav: UINavigationController, assembler: Assembler) {
        self.nav = nav
        self.assembler = assembler
    }
    
    required init() {
        nav = UINavigationController()
        assembler = Assembler([])
        Log.e("Coordinator initialization failed.")
    }
    
    deinit { Log.i(self) }
    
    func start(_ animated: Bool, completion: (() -> Void)?) {
        if let vc = assembler.resolver.resolve(TermsVC.self) {
            nav.pushViewController(vc, animated: animated)
            nav.isNavigationBarHidden = true
            vc.coordinator = self
        } else {
            Log.e("VC init failed")
        }
    }
    
    func startLogin(_ animated: Bool, completion: (() -> Void)?) {
        if let vc = assembler.resolver.resolve(LogInVC.self) {
            nav.pushViewController(vc, animated: animated)
            nav.isNavigationBarHidden = true
            vc.coordinator = self
            Log.e(nav.preferredStatusBarStyle)
        } else {
            Log.e("VC init failed")
        }
    }
}

extension AuthCoordinator: TermsVCDelegate {
    func didTapAgreeButton() {
        if let vc = assembler.resolver.resolve(SignUpVC.self) {
            nav.pushViewController(vc, animated: true)
            vc.coordinator = self
        } else {
            Log.e("VC init failed")
        }
    }
    
    func didTapDisAgreeButton() {
        nav.popViewController(animated: true)
    }
}

extension AuthCoordinator: SignUpVCDelegate {
    func moveToLogin() {
        if let vc = assembler.resolver.resolve(LogInVC.self) {
            nav.pushViewController(vc, animated: true)
            vc.coordinator = self
        } else {
            Log.e("VC init failed")
        }
    }
    
    func moveToMainVC() {
        if let vc = assembler.resolver.resolve(MainVC.self) {
            nav.pushViewController(vc, animated: true)
        } else {
            Log.e("init failed")
        }
    }
}

extension AuthCoordinator: LogInVCDelegate {
    func moveToSignUp() {
        
    }
    
    func loginSuccess() {
        if let coordinator = assembler.resolver.resolve(MainCoordinator.self) {
            coordinator.start(false, completion: nil)
            
            var vcList = self.nav.viewControllers
            vcList.removeAll(where: { $0 is LogInVC })
            // SignUp -> 이미 있는 계정 -> Login -> Login 성공
            vcList.removeAll(where: { $0 is SignUpVC })
            vcList.removeAll(where: { $0 is TermsVC })
            nav.viewControllers = vcList
        } else {
            Log.e("init failed")
        }
    }
}
