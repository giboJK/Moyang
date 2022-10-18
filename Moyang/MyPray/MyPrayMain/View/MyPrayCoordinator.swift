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
    
}
