//
//  PrayController.swift
//  Moyang
//
//  Created by 정김기보 on 2022/08/01.
//

import Foundation
import Alamofire

class PrayController {
    let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }
}

extension PrayController: PrayRepo {
    func addPray(userID: String, groupID: String, content: String, tags: [String], isSecret: Bool,
                 completion: ((Result<BaseResponse, MoyangError>) -> Void)?) {
        let url = networkService.makeUrl(path: NetConst.PrayAPI.addPray)
        let dict: [String: Any] = [
            "group_id": groupID,
            "user_id": userID,
            "content": content,
            "tags": tags,
            "is_secret": isSecret
        ]
        let request = networkService.makeRequest(url: url,
                                                 method: .post,
                                                 parameters: dict)
        networkService.requestAPI(request: request,
                                  type: BaseResponse.self,
                                  token: nil,
                                  encoding: JSONEncoding.default) { result in
            switch result {
            case .success(let response):
                completion?(.success(response))
            case .failure(let error):
                completion?(.failure(.other(error)))
            }
        }
    }
    
    func editPray(userID: String, groupID: String, content: String, tags: [String], isSecret: Bool,
                  completion: ((Result<BaseResponse, MoyangError>) -> Void)?) {
        
    }
    
    func fetchPrayList(groupID: String, userID: String, page: Int, row: Int,
                       completion: ((Result<[GroupIndividualPray], MoyangError>) -> Void)?) {
        
    }
}
