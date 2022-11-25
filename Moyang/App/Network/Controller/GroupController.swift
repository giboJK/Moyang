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


extension GroupController: GroupRepo {
    func registerGroup(userID: String, name: String, desc: String, completion: ((Result<BaseResponse, MoyangError>) -> Void)?) {
        let url = networkService.makeUrl(path: NetConst.GroupAPI.registerGroup)
        let dict: [String: Any] = [
            "user_id": userID,
            "name": name,
            "desc": desc
        ]
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
                completion?(.failure(.other(error)))
            }
        }
    }
    
    func fetchGroupList(userID: String, page: Int, row: Int, completion: ((Result<GroupSearchedGroupListResponse, MoyangError>) -> Void)?) {
        let url = networkService.makeUrl(path: NetConst.GroupAPI.fetchGroupList)
        let dict: [String: Any] = [
            "user_id": userID,
            "page": page,
            "row": row
        ]
        let request = networkService.makeRequest(url: url,
                                                 method: .post,
                                                 parameters: dict)
        networkService.requestAPI(request: request,
                                  type: GroupSearchedGroupListResponse.self,
                                  token: nil) { result in
            switch result {
            case .success(let response):
                completion?(.success(response))
            case .failure(let error):
                completion?(.failure(.other(error)))
            }
        }
    }
    
    func fetchMyGroupSummary(userID: String, completion: ((Result<GroupMediatorInfoListResponse, MoyangError>) -> Void)?) {
        let url = networkService.makeUrl(path: NetConst.GroupAPI.fetchMyGroupSummary)
        let dict: [String: Any] = [
            "user_id": userID
        ]
        let request = networkService.makeRequest(url: url,
                                                 method: .post,
                                                 parameters: dict)
        networkService.requestAPI(request: request,
                                  type: GroupMediatorInfoListResponse.self,
                                  token: nil) { result in
            switch result {
            case .success(let response):
                completion?(.success(response))
            case .failure(let error):
                completion?(.failure(.other(error)))
            }
        }
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
    
    func fetchGroupDetail(groupID: String, completion: ((Result<GroupDetailResponse, MoyangError>) -> Void)?) {
        let url = networkService.makeUrl(path: NetConst.GroupAPI.fetchGroupDetail)
        let dict: [String: Any] = ["group_id": groupID]
        
        let request = networkService.makeRequest(url: url,
                                                 method: .post,
                                                 parameters: dict)
        networkService.requestAPI(request: request,
                                  type: GroupDetailResponse.self,
                                  token: nil) { result in
            switch result {
            case .success(let response):
                completion?(.success(response))
            case .failure(let error):
                completion?(.failure(.other(error)))
            }
        }
    }
    
    func fetchGroupMemberPrayList(groupID: String, userID: String, page: Int, row: Int, completion: ((Result<GroupMemberPrayListResponse, MoyangError>) -> Void)?) {
        let url = networkService.makeUrl(path: NetConst.GroupAPI.fetchGroupMemberPrayList)
        let dict: [String: Any] = ["group_id": groupID,
                                   "user_id": userID,
                                   "page": page,
                                   "row": row]
        
        let request = networkService.makeRequest(url: url,
                                                 method: .post,
                                                 parameters: dict)
        networkService.requestAPI(request: request,
                                  type: GroupMemberPrayListResponse.self,
                                  token: nil) { result in
            switch result {
            case .success(let response):
                completion?(.success(response))
            case .failure(let error):
                completion?(.failure(.other(error)))
            }
        }
    }
    
    func fetchPrayDetail(prayID: String, completion: ((Result<PrayDetailResponse, MoyangError>) -> Void)?) {
        let url = networkService.makeUrl(path: NetConst.PrayAPI.fetchPrayDetail)
        let dict: [String: Any] = [
            "pray_id": prayID
        ]
        let request = networkService.makeRequest(url: url,
                                                 method: .post,
                                                 parameters: dict)
        networkService.requestAPI(request: request,
                                  type: PrayDetailResponse.self,
                                  token: nil) { result in
            switch result {
            case .success(let response):
                completion?(.success(response))
            case .failure(let error):
                completion?(.failure(.other(error)))
            }
        }
    }
    
    // MARK: - Etc
    func exitGroup(groupID: String, userID: String, completion: ((Result<BaseResponse, MoyangError>) -> Void)?) {
        let url = networkService.makeUrl(path: NetConst.GroupAPI.exitGroup)
        let dict: [String: Any] = ["group_id": groupID,
                                   "user_id": userID]
        
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
                completion?(.failure(.other(error)))
            }
        }
    }
    
    func joinGroup(groupID: String, userID: String, completion: ((Result<BaseResponse, MoyangError>) -> Void)?) {
        let url = networkService.makeUrl(path: NetConst.GroupAPI.joinGroup)
        let dict: [String: Any] = ["group_id": groupID,
                                   "user_id": userID]
        
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
                completion?(.failure(.other(error)))
            }
        }
    }
    
    func acceptGroup(reqID: String, isAccepted: Bool, completion: ((Result<BaseResponse, MoyangError>) -> Void)?) {
        let url = networkService.makeUrl(path: NetConst.GroupAPI.acceptGroup)
        let dict: [String: Any] = ["req_id": reqID,
                                   "is_accepted": isAccepted]
        
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
                completion?(.failure(.other(error)))
            }
        }
    }
    
    // MARK: - Add
    func addReply(prayID: String, myID: String, content: String, completion: ((Result<AddReplyResponse, MoyangError>) -> Void)?) {
        let url = networkService.makeUrl(path: NetConst.PrayAPI.addReply)
        let dict: [String: Any] = ["pray_id": prayID,
                                   "user_id": myID,
                                   "content": content
        ]
        
        let request = networkService.makeRequest(url: url,
                                                 method: .post,
                                                 parameters: dict)
        networkService.requestAPI(request: request,
                                  type: AddReplyResponse.self,
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
