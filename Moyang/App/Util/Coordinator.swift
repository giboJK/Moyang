//
//  Coordinator.swift
//  Moyang
//
//  Created by 정김기보 on 2022/05/26.
//

import UIKit
import Swinject

protocol Coordinator {
    var nav: UINavigationController { get set }
    
    var assembler: Assembler { get set }
    
    // MARK: - Functions
    init(nav: UINavigationController, assembler: Assembler)
    
    init()
    
    func start(_ animated: Bool, completion: (() -> Void)?)
}
