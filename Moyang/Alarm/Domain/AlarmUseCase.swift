//
//  AlarmUseCase.swift
//  Moyang
//
//  Created by 정김기보 on 2022/09/29.
//

import Foundation
import RxSwift
import RxCocoa

class AlarmUseCase {
    let repo: AlarmRepo
    
    let alarms = BehaviorRelay<[Alarm]>(value: [])
    
    let error = BehaviorRelay<MoyangError?>(value: nil)
    let isNetworking = BehaviorRelay<Bool>(value: false)
    let isSuccess = BehaviorRelay<Void>(value: ())
    let isFailure = BehaviorRelay<Void>(value: ())
    
    // MARK: - Lifecycle
    init(repo: AlarmRepo) {
        self.repo = repo
    }
    
    func addAlarm(time: String, isOn: Bool, type: AlarmType, day: String) {
        guard let userID = UserData.shared.userInfo?.id else { return }
        repo.addAlarm(userID: userID, time: time, isOn: isOn, type: type.rawValue.uppercased(), day: day) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                if response.code == 0 {
                    var alarms = self.alarms.value
                    alarms.insert(response.data, at: 0)
                    self.alarms.accept(alarms)
                    self.isSuccess.accept(())
                    AlarmCenter.shared.setNotification(type: type, time: time, day: day)
                } else {
                    self.error.accept(.writingFailed)
                    self.isFailure.accept(())
                }
            case .failure(let error):
                Log.e(error)
                self.error.accept(.writingFailed)
                self.isFailure.accept(())
            }
        }
    }
    
    func updateAlarm(alarmID: String, time: String, isOn: Bool, day: String) {
        repo.updateAlarm(alarmID: alarmID, time: time, isOn: isOn, day: day) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                if response.code == 0 {
                    var alarms = self.alarms.value
                    alarms.removeAll { $0.id == response.data.id }
                    alarms.insert(response.data, at: 0)
                    self.alarms.accept(alarms)
                    self.isSuccess.accept(())
                    if let type = AlarmType(rawValue: response.data.type.uppercased()) {
                        AlarmCenter.shared.removeNotification(type: type)
                        if isOn {
                            AlarmCenter.shared.setNotification(type: type, time: time, day: day)
                        }
                    }
                } else {
                    self.error.accept(.writingFailed)
                    self.isFailure.accept(())
                }
            case .failure(let error):
                Log.e(error)
                self.error.accept(.writingFailed)
                self.isFailure.accept(())
            }
        }
    }
    
    func fetchAlarms() {
        guard let userID = UserData.shared.userInfo?.id else { return }
        repo.fetchAlarms(userID: userID) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                if response.code == 0 {
                    self.alarms.accept(response.list)
                } else {
                    self.error.accept(.emptyData)
                }
            case .failure(let error):
                Log.e(error)
                self.error.accept(.unknown)
            }
        }
    }
    
    func deleteAlarm(alarmID: String) {
        repo.deleteAlarm(alarmID: alarmID) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                if response.code == 0 {
                    var alarms = self.alarms.value
                    if let typeStr = alarms.first(where: { $0.id == alarmID })?.type,
                       let type = AlarmType(rawValue: typeStr.uppercased()) {
                        AlarmCenter.shared.removeNotification(type: type)
                    }
                    alarms.removeAll { $0.id == alarmID }
                    self.alarms.accept(alarms)
                    self.isSuccess.accept(())
                } else {
                    self.error.accept(.writingFailed)
                    self.isFailure.accept(())
                }
            case .failure(let error):
                Log.e(error)
                self.error.accept(.writingFailed)
                self.isFailure.accept(())
            }
        }
    }
}
