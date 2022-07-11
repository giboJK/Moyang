//
//  SignUpRepo.swift
//  Moyang
//
//  Created by kibo on 2022/07/11.
//

import Foundation

protocol SignUpRepo {
    func registUser(id: String, pw: String, name: String, completion: ((Result<BaseResponse, Error>) -> Void)?)
}
