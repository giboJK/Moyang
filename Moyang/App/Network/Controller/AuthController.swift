//
//  AuthController.swift
//  Moyang
//
//  Created by kibo on 2022/07/11.
//

import Foundation

class AuthController {
    let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }
}

extension AuthController: AuthRepo {
    func checkEmailExist(email: String, completion: ((Result<BaseResponse, Error>) -> Void)?) {
        let url = networkService.makeUrl(path: NetConst.LoginAPI.checkExist)
        let dict = ["email": email]
        let request = networkService.makeRequest(url: url,
                                                 method: .post,
                                                 parameters: dict)
        
        networkService.requestAPI(request: request,
                                  type: BaseResponse.self,
                                  token: nil) { result in
            switch result {
            case .success(let response):
                completion?(.success(response))
            case .failure(let error):
                completion?(.failure(error))
            }
        }
    }
    
    func registUser(email: String, pw: String, name: String, birth: String, authType: String,
                    completion: ((Result<UserInfo, Error>) -> Void)?) {
        let url = networkService.makeUrl(path: NetConst.LoginAPI.registerUser)
        let userInfo = UserInfoRequest(email: email, passwd: pw, name: name, birth: birth, authType: authType)
        guard let dict = userInfo.dict else { Log.e("Generating json error"); return }
        let request = networkService.makeRequest(url: url,
                                                 method: .post,
                                                 parameters: dict)
        
        networkService.requestAPI(request: request,
                                  type: UserInfo.self,
                                  token: nil) { result in
            switch result {
            case .success(let response):
                completion?(.success(response))
            case .failure(let error):
                completion?(.failure(error))
            }
        }
    }
    
    func appLogin(email: String, credential: String, token: String, completion: ((Result<UserInfo, Error>) -> Void)?) {
        let url = networkService.makeUrl(path: NetConst.LoginAPI.appLogin)
        let request = networkService.makeRequest(url: url,
                                                 method: .post,
                                                 parameters: ["email": email,
                                                              "user_pw": credential,
                                                              "token": token])
        
        networkService.requestAPI(request: request,
                                  type: UserInfo.self,
                                  token: nil) { result in
            switch result {
            case .success(let response):
                completion?(.success(response))
            case .failure(let error):
                completion?(.failure(error))
            }
        }
    }
    
    func checkAppVersion(completion: ((Result<AppVersionInfo, Error>) -> Void)?) {
        let url = networkService.makeUrl(path: NetConst.LoginAPI.appInfo)
        let request = networkService.makeRequest(url: url,
                                                 method: .post,
                                                 parameters: [:])
        
        networkService.requestAPI(request: request,
                                  type: AppVersionInfo.self,
                                  token: nil) { result in
            switch result {
            case .success(let response):
                completion?(.success(response))
            case .failure(let error):
                completion?(.failure(error))
            }
        }
    }
}
