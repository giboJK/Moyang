//
//  ProfileController.swift
//  Moyang
//
//  Created by 정김기보 on 2022/09/29.
//

import Foundation
import Alamofire

class ProfileController {
    let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }
}

extension ProfileController: NoticeRepo {
    func fetchNotices(page: Int, row: Int, completion: ((Result<FetchNoticesResponse, Error>) -> Void)?) {
        let url = networkService.makeUrl(path: NetConst.NoticeAPI.fetchNotices)
        let request = networkService.makeRequest(url: url,
                                                 method: .post,
                                                 parameters: ["page": page,
                                                              "row": row])
        
        networkService.requestAPI(request: request,
                                  type: FetchNoticesResponse.self,
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

extension ProfileController: AlarmRepo {
    func addAlarm(userID: String, time: String, isOn: Bool, type: String, day: String, completion: ((Result<AddAlarmResponse, Error>) -> Void)?) {
        let url = networkService.makeUrl(path: NetConst.AlarmAPI.addAlarm)
        let request = networkService.makeRequest(url: url,
                                                 method: .post,
                                                 parameters: ["user_id": userID,
                                                              "time": time,
                                                              "is_on": isOn,
                                                              "type": type,
                                                              "day": day])
        
        networkService.requestAPI(request: request,
                                  type: AddAlarmResponse.self,
                                  token: nil) { result in
            switch result {
            case .success(let response):
                completion?(.success(response))
            case .failure(let error):
                completion?(.failure(error))
            }
        }
    }
    
    func updateAlarm(alarmID: String, time: String, isOn: Bool, day: String, completion: ((Result<UpdateAlarmResponse, Error>) -> Void)?) {
        let url = networkService.makeUrl(path: NetConst.AlarmAPI.updateAlarm)
        let request = networkService.makeRequest(url: url,
                                                 method: .post,
                                                 parameters: ["alarm_id": alarmID,
                                                              "time": time,
                                                              "is_on": isOn,
                                                              "day": day])
        
        networkService.requestAPI(request: request,
                                  type: UpdateAlarmResponse.self,
                                  token: nil) { result in
            switch result {
            case .success(let response):
                completion?(.success(response))
            case .failure(let error):
                completion?(.failure(error))
            }
        }
    }
    
    func fetchAlarms(userID: String, completion: ((Result<FetchAlarmsResponse, Error>) -> Void)?) {
        let url = networkService.makeUrl(path: NetConst.AlarmAPI.fetchAlarms)
        let request = networkService.makeRequest(url: url,
                                                 method: .post,
                                                 parameters: ["user_id": userID])
        
        networkService.requestAPI(request: request,
                                  type: FetchAlarmsResponse.self,
                                  token: nil) { result in
            switch result {
            case .success(let response):
                completion?(.success(response))
            case .failure(let error):
                completion?(.failure(error))
            }
        }
    }
    
    func deleteAlarm(alarmID: String, completion: ((Result<BaseResponse, Error>) -> Void)?) {
        let url = networkService.makeUrl(path: NetConst.AlarmAPI.deleteAlarm)
        let request = networkService.makeRequest(url: url,
                                                 method: .post,
                                                 parameters: ["alarm_id": alarmID])
        
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
}
