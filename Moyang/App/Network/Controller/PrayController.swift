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

extension PrayController: MyPrayRepo {
    
    // MARK: - Add
    
    func addPray(userID: String, title: String, content: String, completion: ((Result<AddPrayResponse, MoyangError>) -> Void)?) {
        let url = networkService.makeUrl(path: NetConst.PrayAPI.addPray)
        let dict: [String: Any] = [
            "user_id": userID,
            "title": title,
            "content": content
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
    
    // MARK: - Update
    
    func updatePray(prayID: String, title: String, content: String, completion: ((Result<BaseResponse, MoyangError>) -> Void)?) {
        let url = networkService.makeUrl(path: NetConst.PrayAPI.updatePray)
        let dict: [String: Any] = [
            "pray_id": prayID,
            "title": title,
            "content": content
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
    
    // MARK: - Delete
    
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
    
    // MARK: - Fetch
    func fetchPray(prayID: String, completion: ((Result<MyPray, MoyangError>) -> Void)?) {
        let url = networkService.makeUrl(path: NetConst.PrayAPI.fetchPray)
        let dict: [String: Any] = [
            "pray_id": prayID
        ]
        let request = networkService.makeRequest(url: url,
                                                 method: .post,
                                                 parameters: dict)
        networkService.requestAPI(request: request,
                                  type: MyPray.self,
                                  token: nil) { result in
            switch result {
            case .success(let response):
                completion?(.success(response))
            case .failure(let error):
                completion?(.failure(.other(error)))
            }
        }
    }
    
    func fetchPrayList(userID: String, page: Int, row: Int, completion: ((Result<[MyPray], MoyangError>) -> Void)?) {
        let url = networkService.makeUrl(path: NetConst.PrayAPI.fetchPrayList)
        let dict: [String: Any] = [
            "user_id": userID,
            "page": page,
            "row": row
        ]
        let request = networkService.makeRequest(url: url,
                                                 method: .post,
                                                 parameters: dict)
        networkService.requestAPI(request: request,
                                  type: [MyPray].self,
                                  token: nil) { result in
            switch result {
            case .success(let response):
                completion?(.success(response))
            case .failure(let error):
                completion?(.failure(.other(error)))
            }
        }
    }
    
    func fetchSummary(userID: String, date: String, completion: ((Result<PraySummaryResponse, MoyangError>) -> Void)?) {
        let url = networkService.makeUrl(path: NetConst.PrayAPI.fetchPraySummary)
        let dict: [String: Any] = ["user_id": userID, "date": date]
        let request = networkService.makeRequest(url: url,
                                                 method: .post,
                                                 parameters: dict)
        networkService.requestAPI(request: request,
                                  type: PraySummaryResponse.self,
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
    func fetchMyGroupList(userID: String, completion: ((Result<MyGroupListResponse, MoyangError>) -> Void)?) {
        let url = networkService.makeUrl(path: NetConst.PrayAPI.fetchMyGroupList)
        let dict: [String: Any] = [
            "user_id": userID
        ]
        let request = networkService.makeRequest(url: url,
                                                 method: .post,
                                                 parameters: dict)
        networkService.requestAPI(request: request,
                                  type: MyGroupListResponse.self,
                                  token: nil) { result in
            switch result {
            case .success(let response):
                completion?(.success(response))
            case .failure(let error):
                completion?(.failure(.other(error)))
            }
        }
    }
    
    func fetchGroupAcitvity(groupID: String, isWeek: Bool, date: String, completion: ((Result<GroupEventResponse, MoyangError>) -> Void)?) {
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
    
    func fetchPrayAll(groupID: String, userID: String, order: String, page: Int, row: Int,
                      completion: ((Result<[MyPray], MoyangError>) -> Void)?) {
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
                                  type: [MyPray].self,
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
