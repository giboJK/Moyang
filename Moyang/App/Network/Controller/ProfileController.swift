//
//  ProfileController.swift
//  Moyang
//
//  Created by 정김기보 on 2022/09/29.
//

import Foundation
import Alamofire

class ProfileController {
    let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }
}

extension ProfileController: AlarmRepo {
    func getAlarms() {
        
    }
}
