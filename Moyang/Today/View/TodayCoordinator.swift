//
//  TodayCoordinator.swift
//  Moyang
//
//  Created by kibo on 2022/08/10.
//

import Foundation
import Swinject
import UIKit

class TodayCoordinator: Coordinator {
    
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
        if let vc = assembler.resolver.resolve(TodayVC.self) {
            nav.pushViewController(vc, animated: true)
            vc.coordinator = self
        } else {
            Log.e("error")
        }
    }
}


// MARK: - TodayVCDelegate
extension TodayCoordinator: TodayVCDelegate {
    func didTapTaskItem(taskDetailVM: TaskDetailVM) {
        if let vc = assembler.resolver.resolve(TaskDetailVC.self, argument: taskDetailVM) {
            nav.pushViewController(vc, animated: true)
            vc.coordinator = self
        } else {
            Log.e("error")
        }
    }
}


// MARK: - TaskDetailVCDelegate
extension TodayCoordinator: TaskDetailVCDelegate {
    
}
