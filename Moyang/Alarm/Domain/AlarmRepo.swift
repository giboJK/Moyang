//
//  AlarmRepo.swift
//  Moyang
//
//  Created by 정김기보 on 2022/09/29.
//

import Foundation

protocol AlarmRepo {
    func addAlarm(userID: String, time: String, isOn: Bool, type: String, completion: ((Result<AddAlarmResponse, Error>) -> Void)?)
    func updateAlarm(alarmID: String, time: String, isOn: Bool, completion: ((Result<UpdateAlarmResponse, Error>) -> Void)?)
    func fetchAlarms(userID: String, completion: ((Result<FetchAlarmsResponse, Error>) -> Void)?)
    func deleteAlarm(alarmID: String, completion: ((Result<BaseResponse, Error>) -> Void)?)
}


// MARK: - Response
class AddAlarmResponse: BaseResponse {
    let data: Alarm
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        data = try container.decode(Alarm.self, forKey: .data)
        try super.init(from: decoder)
    }
    
    enum CodingKeys: String, CodingKey {
        case data
    }
}

class UpdateAlarmResponse: BaseResponse {
    let data: Alarm
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        data = try container.decode(Alarm.self, forKey: .data)
        try super.init(from: decoder)
    }
    
    enum CodingKeys: String, CodingKey {
        case data
    }
}

class FetchAlarmsResponse: BaseResponse {
    let list: [Alarm]
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        list = try container.decode([Alarm].self, forKey: .list)
        try super.init(from: decoder)
    }
    
    enum CodingKeys: String, CodingKey {
        case list
    }
}
