//
//  PrayController.swift
//  Moyang
//
//  Created by 정김기보 on 2022/08/01.
//

import Foundation

class PrayController {
    let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }
}

extension PrayController: PrayRepo {
    func addPray(content: String, tags: [String], isSecret: Bool, completion: ((Result<Int, MoyangError>) -> Void)?) {
        
    }
    
    func editPray(content: String, tags: [String], isSecret: Bool, completion: ((Result<Int, MoyangError>) -> Void)?) {
        
    }
}
