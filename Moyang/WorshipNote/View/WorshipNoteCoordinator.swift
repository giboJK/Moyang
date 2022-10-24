//
//  WorshipNoteCoordinator.swift
//  Moyang
//
//  Created by kibo on 2022/10/24.
//

import Foundation
import Swinject
import UIKit

class WorshipNoteCoordinator: Coordinator {
    
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

extension WorshipNoteCoordinator: NoteMainVCDelegate {
    func didTapEmptyView() {
    }
}
