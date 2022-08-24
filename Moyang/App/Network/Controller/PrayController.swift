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
    let fsShared = FSServiceImplShared()
    
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }
}

extension PrayController: PrayRepo {
    func fetchPray(prayID: String, completion: ((Result<GroupIndividualPray, MoyangError>) -> Void)?) {
        
    }
    
    func fetchTagAutocomplete(tag: String, completion: ((Result<TagAutocompleteResponse, MoyangError>) -> Void)?) {
        let url = networkService.makeUrl(path: NetConst.PrayAPI.searchTag)
        let dict: [String: Any] = [
            "tag": tag
        ]
        let request = networkService.makeRequest(url: url,
                                                 method: .post,
                                                 parameters: dict)
        networkService.requestAPI(request: request,
                                  type: TagAutocompleteResponse.self,
                                  token: nil) { result in
            switch result {
            case .success(let response):
                completion?(.success(response))
            case .failure(let error):
                completion?(.failure(.other(error)))
            }
        }
    }
    
    func searchPrays(tag: String, groupID: String, completion: ((Result<PraySearchResponse, MoyangError>) -> Void)?) {
        let url = networkService.makeUrl(path: NetConst.PrayAPI.searchPray)
        let dict: [String: Any] = [
            "tag": tag,
            "group_id": groupID
        ]
        let request = networkService.makeRequest(url: url,
                                                 method: .post,
                                                 parameters: dict)
        networkService.requestAPI(request: request,
                                  type: PraySearchResponse.self,
                                  token: nil) { result in
            switch result {
            case .success(let response):
                completion?(.success(response))
            case .failure(let error):
                completion?(.failure(.other(error)))
            }
        }
        
    }
    
    func fetchGroupAcitvity(groupID: String, isWeek: Bool, date: String, completion: ((Result<GroupActivityResponse, MoyangError>) -> Void)?) {
        let url = networkService.makeUrl(path: NetConst.GroupAPI.fetchGroupActivity)
        let dict: [String: Any] = [
            "group_id": groupID,
            "is_week": isWeek,
            "date": date
        ]
        let request = networkService.makeRequest(url: url,
                                                 method: .post,
                                                 parameters: dict)
        networkService.requestAPI(request: request,
                                  type: GroupActivityResponse.self,
                                  token: nil) { result in
            switch result {
            case .success(let response):
                completion?(.success(response))
            case .failure(let error):
                completion?(.failure(.other(error)))
            }
        }
    }
    
    func updateReply(replyID: String, reply: String, completion: ((Result<BaseResponse, MoyangError>) -> Void)?) {
        let url = networkService.makeUrl(path: NetConst.PrayAPI.updateReply)
        let dict: [String: Any] = [
            "reply_id": replyID,
            "reply": reply
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
    
    func deleteReply(replyID: String, completion: ((Result<BaseResponse, MoyangError>) -> Void)?) {
        let url = networkService.makeUrl(path: NetConst.PrayAPI.deleteReply)
        let dict: [String: Any] = ["reply_id": replyID]
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
    
    
    func addPray(userID: String, groupID: String, content: String, tags: [String], isSecret: Bool,
                 completion: ((Result<AddPrayResponse, MoyangError>) -> Void)?) {
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
                                  type: AddPrayResponse.self,
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
    
    func updatePray(prayID: String, pray: String, tags: [String], isSecret: Bool, completion: ((Result<BaseResponse, MoyangError>) -> Void)?) {
        let url = networkService.makeUrl(path: NetConst.PrayAPI.updatePray)
        let dict: [String: Any] = [
            "pray_id": prayID,
            "content": pray,
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
    
    func fetchPrayList(groupID: String, userID: String, isMe: Bool, order: String, page: Int, row: Int,
                       completion: ((Result<[GroupIndividualPray], MoyangError>) -> Void)?) {
        let url = networkService.makeUrl(path: NetConst.PrayAPI.fetchPrayList)
        let dict: [String: Any] = [
            "group_id": groupID,
            "user_id": userID,
            "is_me": isMe,
            "order": order,
            "page": page,
            "row": row
        ]
        let request = networkService.makeRequest(url: url,
                                                 method: .post,
                                                 parameters: dict)
        networkService.requestAPI(request: request,
                                  type: [GroupIndividualPray].self,
                                  token: nil) { result in
            switch result {
            case .success(let response):
                completion?(.success(response))
            case .failure(let error):
                completion?(.failure(.other(error)))
            }
        }
    }
    
    func fetchPrayAll(groupID: String, userID: String, order: String, page: Int, row: Int,
                      completion: ((Result<[GroupIndividualPray], MoyangError>) -> Void)?) {
        let url = networkService.makeUrl(path: NetConst.PrayAPI.fetchPrayAll)
        let dict: [String: Any] = [
            "group_id": groupID,
            "user_id": userID,
            "order": order,
            "page": page,
            "row": row
        ]
        let request = networkService.makeRequest(url: url,
                                                 method: .post,
                                                 parameters: dict)
        networkService.requestAPI(request: request,
                                  type: [GroupIndividualPray].self,
                                  token: nil) { result in
            switch result {
            case .success(let response):
                completion?(.success(response))
            case .failure(let error):
                completion?(.failure(.other(error)))
            }
        }
    }
    
    func deletePray(prayID: String, completion: ((Result<BaseResponse, MoyangError>) -> Void)?) {
        let url = networkService.makeUrl(path: NetConst.PrayAPI.deletePray)
        let dict: [String: Any] = ["pray_id": prayID]
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
    
    func addReaction(userID: String, prayID: String, type: Int, completion: ((Result<AddPrayReactionResponse, MoyangError>) -> Void)?) {
        let url = networkService.makeUrl(path: NetConst.PrayAPI.addReaction)
        let dict: [String: Any] = ["user_id": userID,
                                   "pray_id": prayID,
                                   "type": type]
        let request = networkService.makeRequest(url: url,
                                                 method: .post,
                                                 parameters: dict)
        networkService.requestAPI(request: request,
                                  type: AddPrayReactionResponse.self,
                                  token: nil) { result in
            switch result {
            case .success(let response):
                completion?(.success(response))
            case .failure(let error):
                completion?(.failure(.other(error)))
            }
        }
    }
    
    func addAnswer(userID: String, prayID: String, answer: String, completion: ((Result<AddPrayAnswerResponse, MoyangError>) -> Void)?) {
        let url = networkService.makeUrl(path: NetConst.PrayAPI.addAnswer)
        let dict: [String: Any] = ["user_id": userID,
                                   "pray_id": prayID,
                                   "answer": answer]
        let request = networkService.makeRequest(url: url,
                                                 method: .post,
                                                 parameters: dict)
        networkService.requestAPI(request: request,
                                  type: AddPrayAnswerResponse.self,
                                  token: nil) { result in
            switch result {
            case .success(let response):
                completion?(.success(response))
            case .failure(let error):
                completion?(.failure(.other(error)))
            }
        }
    }
    
    func addReply(userID: String, prayID: String, reply: String, completion: ((Result<AddPrayReplyResponse, MoyangError>) -> Void)?) {
        let url = networkService.makeUrl(path: NetConst.PrayAPI.addReply)
        let dict: [String: Any] = ["user_id": userID,
                                   "pray_id": prayID,
                                   "content": reply]
        let request = networkService.makeRequest(url: url,
                                                 method: .post,
                                                 parameters: dict)
        networkService.requestAPI(request: request,
                                  type: AddPrayReplyResponse.self,
                                  token: nil) { result in
            switch result {
            case .success(let response):
                completion?(.success(response))
            case .failure(let error):
                completion?(.failure(.other(error)))
            }
        }
    }
    
    func addChange(prayID: String, content: String, completion: ((Result<AddPrayChangeResponse, MoyangError>) -> Void)?) {
        let url = networkService.makeUrl(path: NetConst.PrayAPI.addChange)
        let dict: [String: Any] = ["pray_id": prayID,
                                   "content": content]
        let request = networkService.makeRequest(url: url,
                                                 method: .post,
                                                 parameters: dict)
        networkService.requestAPI(request: request,
                                  type: AddPrayChangeResponse.self,
                                  token: nil) { result in
            switch result {
            case .success(let response):
                completion?(.success(response))
            case .failure(let error):
                completion?(.failure(.other(error)))
            }
        }
    }
    
    func addAmen(userID: String, groupID: String, time: Int, completion: ((Result<BaseResponse, MoyangError>) -> Void)?) {
        let url = networkService.makeUrl(path: NetConst.PrayAPI.addAmen)
        let dict: [String: Any] = ["user_id": userID,
                                   "group_id": groupID,
                                   "time": time]
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
    
    func downloadSong(fileName: String, path: String, fileExt: String,
                      completion: ((Result<URL, MoyangError>) -> Void)?) {
        if hasFile(fileName: fileName, path: path, fileExt: fileExt) {
            let documentsUrl: URL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let localURL = documentsUrl.appendingPathComponent(path + "/" + fileName + "." + fileExt)
            completion?(.success(localURL))
        } else {
            fsShared.downloadFile(fileName: fileName, path: path, fileExt: fileExt, completion: completion)
        }
    }
    
    private func hasFile(fileName: String, path: String, fileExt: String) -> Bool {
        let documentsUrl: URL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let localURL = documentsUrl.appendingPathComponent(path + "/" + fileName + "." + fileExt)
        
        return FileManager.default.fileExists(atPath: localURL.path)
    }
}
