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
    
    
    // MARK: - Lifecycle
    init(repo: AlarmRepo) {
        self.repo = repo
    }
    
    func addAlarm(time: String, isOn: Bool) {
        guard let userID = UserData.shared.userInfo?.id else { return }
        repo.addAlarm(userID: userID, time: time, isOn: isOn) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                if response.code == 0 {
                    var alarms = self.alarms.value
                    alarms.insert(response.data, at: 0)
                    self.alarms.accept(alarms)
                } else {
                    self.error.accept(.writingFailed)
                }
            case .failure(let error):
                Log.e(error)
                self.error.accept(.writingFailed)
            }
        }
    }
    
    func updateAlarm(alarmID: String, time: String, isOn: Bool) {
        repo.updateAlarm(alarmID: alarmID, time: time, isOn: isOn) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                if response.code == 0 {
                    var alarms = self.alarms.value
                    alarms.removeAll { $0.id == response.data.id }
                    alarms.insert(response.data, at: 0)
                    self.alarms.accept(alarms)
                } else {
                    self.error.accept(.writingFailed)
                }
            case .failure(let error):
                Log.e(error)
                self.error.accept(.writingFailed)
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
                    alarms.removeAll { $0.id == alarmID }
                    self.alarms.accept(alarms)
                } else {
                    self.error.accept(.writingFailed)
                }
            case .failure(let error):
                Log.e(error)
                self.error.accept(.writingFailed)
            }
        }
    }
}
