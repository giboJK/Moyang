//
//  AuthRepo.swift
//  Moyang
//
//  Created by kibo on 2022/07/11.
//

import Foundation

protocol AuthRepo {
    func checkEmailExist(email: String, completion: ((Result<BaseResponse, Error>) -> Void)?)
    func registUser(email: String, pw: String, name: String, birth: String, authType: String,
                    completion: ((Result<UserInfo, Error>) -> Void)?)
    
    func appLogin(email: String, credential: String, token: String, completion: ((Result<UserInfo, Error>) -> Void)?)
    
    func checkAppVersion(completion: ((Result<AppVersionInfo, Error>) -> Void)?)
    
    func deleteUser(myID: String, completion: ((Result<BaseResponse, Error>) -> Void)?)
}

enum AuthType: String {
    case google = "GOOGLE"
    case apple = "APPLE"
}
