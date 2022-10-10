//
//  GroupController.swift
//  Moyang
//
//  Created by 정김기보 on 2022/05/25.
//

import Foundation

class GroupController {
    let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }
}

extension GroupController: CommunityMainRepo {
    func fetchGroupSummary(myInfo: UserInfo, completion: ((Result<GroupSummary, MoyangError>) -> Void)?) {
        let url = networkService.makeUrl(path: NetConst.GroupAPI.fetchGroupSummary)
        let dict = ["user_id": myInfo.id]
        let request = networkService.makeRequest(url: url,
                                                 method: .post,
                                                 parameters: dict)
        networkService.requestAPI(request: request,
                                  type: GroupSummary.self,
                                  token: nil) { result in
            switch result {
            case .success(let response):
                completion?(.success(response))
            case .failure(let error):
                completion?(.failure(.other(error)))
            }
        }
    }
    
    func fetchGroupInfo(community: String, groupID: String, completion: ((Result<GroupInfo, MoyangError>) -> Void)?) {
    }
    
    func fetchGroupEvent(groupID: String, isWeek: Bool, date: String, completion: ((Result<GroupEventResponse, MoyangError>) -> Void)?) {
        let url = networkService.makeUrl(path: NetConst.GroupAPI.fetchGroupEvent)
        let dict: [String: Any] = [
            "group_id": groupID,
            "is_week": isWeek,
            "date": date
        ]
        let request = networkService.makeRequest(url: url,
                                                 method: .post,
                                                 parameters: dict)
        networkService.requestAPI(request: request,
                                  type: GroupEventResponse.self,
                                  token: nil) { result in
            switch result {
            case .success(let response):
                completion?(.success(response))
            case .failure(let error):
                completion?(.failure(.other(error)))
            }
        }
    }
}
extension GroupController: GroupRepo {
    func fetchGroupList() {
        
    }
}
