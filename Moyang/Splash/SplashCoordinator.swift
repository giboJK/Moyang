//
//  SplashCoordinator.swift
//  Moyang
//
//  Created by 정김기보 on 2022/08/27.
//

import Foundation
import Swinject
import UIKit

class SplashCoordinator: Coordinator {
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
        if let vc = assembler.resolver.resolve(SplashVC.self) {
            nav.pushViewController(vc, animated: animated)
            nav.isNavigationBarHidden = true
            vc.coordinator = self
        } else {
            Log.e("VC init failed")
        }
    }
}

extension SplashCoordinator: SplashVCDelegate {
    func loginSuccess() {
        if let coordinator = assembler.resolver.resolve(MainCoordinator.self) {
            coordinator.start(false) {
                Log.d("Auto Login Success")
            }
        } else {
            Log.e("init failed")
        }
    }
    
    func loginFailure() {
        if let coordinator = assembler.resolver.resolve(IntroCoordinator.self) {
            coordinator.start(false, completion: nil)
        } else {
            Log.e("Init failed")
        }
    }
}
