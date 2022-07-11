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

extension AuthController: SignUpRepo {
    func registUser(id: String, pw: String, name: String, completion: ((Result<BaseResponse, Error>) -> Void)?) {
        let url = networkService.makeUrl(path: NetConst.APIPath.registUser)
        let userInfo = UserInfo(id: id, name: name, passwd: pw)
        guard let dict = userInfo.dict else { Log.e("Generating json error"); return }
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
                Log.e("")
            }
        }
    }
}
