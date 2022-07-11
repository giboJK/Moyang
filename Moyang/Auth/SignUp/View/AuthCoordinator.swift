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
    
}
