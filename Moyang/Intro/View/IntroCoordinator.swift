//
//  IntroCoordinator.swift
//  Moyang
//
//  Created by 정김기보 on 2022/07/11.
//

import Foundation
import Swinject
import UIKit

class IntroCoordinator: Coordinator {
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
        if let vc = assembler.resolver.resolve(IntroVC.self) {
            nav.pushViewController(vc, animated: animated)
            nav.isNavigationBarHidden = true
            vc.coordinator = self
        } else {
            Log.e("VC init failed")
        }
    }
}

extension IntroCoordinator: IntroVCDelegate {
    func didTapSignUpButton() {
        if let coordinator = assembler.resolver.resolve(AuthCoordinator.self) {
            coordinator.start(true, completion: nil)
            nav.isNavigationBarHidden = false
        } else {
            Log.e("VC init failed")
        }
    }
    
    func didTapLogInButton() {
        if let coordinator = assembler.resolver.resolve(AuthCoordinator.self) {
            coordinator.startLogin(true, completion: nil)
            nav.isNavigationBarHidden = false
        } else {
            Log.e("VC init failed")
        }
    }
    
    func didTapPastorLogInButton() {
        
    }
}
