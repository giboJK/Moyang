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
        var tagsParam = ""
        tags.forEach { tag in
            tagsParam += "\(tag)" + ","
        }
        if !tagsParam.isEmpty {
            tagsParam.removeLast()
        }
        let dict = ["group_id": groupID,
                    "user_id": userID,
                    "content": content,
                    "tags": tagsParam,
                    "is_secret": isSecret] as [String: Any]
        let request = networkService.makeRequest(url: url,
                                                 method: .post,
                                                 parameters: dict)
        networkService.requestAPI(request: request,
                                  type: BaseResponse.self,
                                  token: nil,
                                  encoding: URLEncoding(arrayEncoding: .noBrackets)) { result in
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
}
