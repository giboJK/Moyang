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
    
    func addPray(userID: String, category: String, content: String, groupID: String, completion: ((Result<AddPrayResponse, MoyangError>) -> Void)?) {
        let url = networkService.makeUrl(path: NetConst.PrayAPI.addPray)
        let dict: [String: Any] = [
            "group_id": groupID,
            "user_id": userID,
            "category": category,
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
    
    
    func addAnswer(prayID: String, answer: String, completion: ((Result<AddPrayAnswerResponse, MoyangError>) -> Void)?) {
        let url = networkService.makeUrl(path: NetConst.PrayAPI.addAnswer)
        let dict: [String: Any] = ["pray_id": prayID,
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
    
    func addChange(prayID: String, change: String, completion: ((Result<AddPrayChangeResponse, MoyangError>) -> Void)?) {
        let url = networkService.makeUrl(path: NetConst.PrayAPI.addChange)
        let dict: [String: Any] = ["pray_id": prayID,
                                   "change": change]
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
    
    func addPrayGroupInfo(groupID: String, prayID: String, completion: ((Result<BaseResponse, MoyangError>) -> Void)?) {
        let url = networkService.makeUrl(path: NetConst.PrayAPI.addPrayGroupInfo)
        let dict: [String: Any] = ["group_id": groupID,
                                   "pray_id": prayID]
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
    
    // MARK: - Update
    
    func updatePray(prayID: String, category: String, content: String, groupID: String, completion: ((Result<BaseResponse, MoyangError>) -> Void)?) {
        let url = networkService.makeUrl(path: NetConst.PrayAPI.updatePray)
        let dict: [String: Any] = ["pray_id": prayID,
                                   "category": category,
                                   "content": content,
                                   "group_id": groupID
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
    
    
    func updateChange(changeID: String, change: String, completion: ((Result<BaseResponse, MoyangError>) -> Void)?) {
        let url = networkService.makeUrl(path: NetConst.PrayAPI.updateChange)
        let dict: [String: Any] = ["change_id": changeID,
                                   "change": change
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
    
    func updateAnswer(answerID: String, answer: String, completion: ((Result<BaseResponse, MoyangError>) -> Void)?) {
        let url = networkService.makeUrl(path: NetConst.PrayAPI.updateAnswer)
        let dict: [String: Any] = ["answer_id": answerID,
                                   "answer": answer
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
    
    func updatePrayReadInfo(infoID: String, completion: ((Result<BaseResponse, MoyangError>) -> Void)?) {
        let url = networkService.makeUrl(path: NetConst.PrayAPI.updateReadInfo)
        let dict: [String: Any] = ["info_id": infoID,
                                   "state": 1
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
    
    func deleteChange(changeID: String, completion: ((Result<BaseResponse, MoyangError>) -> Void)?) {
        let url = networkService.makeUrl(path: NetConst.PrayAPI.deleteChange)
        let dict: [String: Any] = ["change_id": changeID]
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
    
    func deleteAnswer(answerID: String, completion: ((Result<BaseResponse, MoyangError>) -> Void)?) {
        let url = networkService.makeUrl(path: NetConst.PrayAPI.deleteAnswer)
        let dict: [String: Any] = ["answer_id": answerID]
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
    
    // MARK: - Download
    
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
