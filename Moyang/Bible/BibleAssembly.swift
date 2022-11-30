//
//  BibleAssembly.swift
//  Moyang
//
//  Created by 정김기보 on 2022/10/16.
//

import Swinject
import SwinjectAutoregistration
import Foundation
import UIKit

class BibleAssembly: Assembly, BaseAssembly {
    var nav: UINavigationController?
    
    deinit { Log.i(self) }
    
    func assemble(container: Container) {
        container.register(NetworkServiceProtocol.self) { _ in
            AFNetworkService(sessionConfiguration: .default)
        }
        
        // MARK: - Bible
        
        // MARK: - Coordinator
    }
}
