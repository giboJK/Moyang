//
//  MyPrayUseCase.swift
//  Moyang
//
//  Created by 정김기보 on 2022/06/28.
//

import Foundation
import RxSwift
import RxCocoa

class MyPrayUseCase {
    let repo: MyPrayRepo
    
    // MARK: - MyPray
    let myPraySummary = BehaviorRelay<MyPraySummary?>(value: nil)
    let myPrayList = BehaviorRelay<[MyPray]>(value: [])
    let myGroupList = BehaviorRelay<[MyGroup]>(value: [])
    
    // MARK: - Event
    let addPraySuccess = BehaviorRelay<Void>(value: ())
    let addPrayFailure = BehaviorRelay<Void>(value: ())
    let updatePraySuccess = BehaviorRelay<Void>(value: ())
    let updatePrayFailure = BehaviorRelay<Void>(value: ())
    let deletePraySuccess = BehaviorRelay<Void>(value: ())
    let deletePrayFailure = BehaviorRelay<Void>(value: ())
    
    let fetchPraySuccess = BehaviorRelay<MyPray?>(value: nil)
    let fetchPrayFailure = BehaviorRelay<Void>(value: ())
    
    let addChangeSuccess = BehaviorRelay<Void>(value: ())
    let addChangeFailure = BehaviorRelay<Void>(value: ())
    
    let addAnswerSuccess = BehaviorRelay<Void>(value: ())
    let addAnswerFailure = BehaviorRelay<Void>(value: ())
    
    // MARK: - GroupPraying
    let songName = BehaviorRelay<String?>(value: nil)
    let songURL = BehaviorRelay<URL?>(value: nil)
    
    // MARK: - Default events
    let isNetworking = BehaviorRelay<Bool>(value: false)
    
    
    // MARK: - Lifecycle
    init(repo: MyPrayRepo) {
        self.repo = repo
    }
    
    // MARK: - Functions
    // MARK: - Add
    
    func addPray(title: String, content: String, groupID: String) {
        guard let myID = UserData.shared.userInfo?.id else { Log.e("No user ID"); return }
        if checkAndSetIsNetworking() { return }
        repo.addPray(userID: myID,
                     title: title,
                     content: content,
                     groupID: groupID) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                if response.code == 0 {
                    var curList = self.myPrayList.value
                    curList.insert(response.data, at: 0)
                    self.myPrayList.accept(curList)
                    self.addPraySuccess.accept(())
                } else {
                    self.addPrayFailure.accept(())
                }
            case .failure(let error):
                Log.e(error)
                self.addPrayFailure.accept(())
            }
            self.resetIsNetworking()
        }
    }
    
    func addAnswer(prayID: String, answer: String) {
    }
    
    func addChange(prayID: String, content: String) {
    }
    
    func addPrayGroupInfo(groupID: String, prayID: String) {
        
    }
    
    // MARK: - Fetch
    func fetchSummary(date: String) {
        guard let myID = UserData.shared.userInfo?.id else { Log.e("No user ID"); return }
        if checkAndSetIsNetworking() { return }
        repo.fetchSummary(userID: myID, date: date) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                if response.code == 0 {
                    self.myPraySummary.accept(response.data)
                } else {
                    Log.e(response.errorMessage ?? "")
                }
            case .failure(let error):
                Log.e(error)
            }
            self.resetIsNetworking()
        }
    }
    
    func fetchPrayList(userID: String, page: Int, row: Int = 7) {
        if checkAndSetIsNetworking() {
            return
        }
        repo.fetchPrayList(userID: userID, page: page, row: row) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let list):
                var curList = self.myPrayList.value
                curList.append(contentsOf: list)
                self.myPrayList.accept(curList)
            case .failure(let error):
                Log.e(error)
            }
            self.resetIsNetworking()
        }
    }
    
    func fetchMyGroupList() {
        guard let userID = UserData.shared.userInfo?.id else {
            Log.e("No userID??")
            return
        }
        repo.fetchMyGroupList(userID: userID) { [weak self] result in
            switch result {
            case .success(let response):
                self?.myGroupList.accept(response.groups)
            case .failure(let error):
                Log.e(error)
            }
        }
    }
    
    func fetchPray(prayID: String, userID: String) {
    }
    
    
    // MARK: - Update
    func updatePray(prayID: String, title: String, content: String) {
        if checkAndSetIsNetworking() { return }
        repo.updatePray(prayID: prayID, title: title, content: content) { [weak self] result in
            switch result {
            case .success(let response):
                if response.code == 0 {
                    self?.updatePraySuccess.accept(())
                } else {
                    self?.updatePrayFailure.accept(())
                }
            case .failure(let error):
                Log.e(error)
                self?.addPrayFailure.accept(())
            }
            self?.resetIsNetworking()
        }
    }
    
    // MARK: - Delete
    func deletePray(prayID: String) {
        if checkAndSetIsNetworking() { return }
        repo.deletePray(prayID: prayID) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                if response.code == 0 {
                    self.deletePraySuccess.accept(())
                    var curList = self.myPrayList.value
                    curList.removeAll { $0.prayID == prayID }
                    self.myPrayList.accept(curList)
                } else {
                    self.deletePrayFailure.accept(())
                }
            case .failure(let error):
                Log.e(error)
                self.deletePrayFailure.accept(())
            }
            self.resetIsNetworking()
        }
    }
    
    
    // MARK: - Firestore
    func loadSong() {
        downloadSong()
    }
    
    
    // MARK: - Local function
    private func downloadSong(fileName: String = "Road to God", fileExt: String = "mp3") {
        repo.downloadSong(fileName: fileName, path: "music/", fileExt: "mp3") { [weak self] result in
            switch result {
            case .success(let url):
                Log.d(url)
                self?.songName.accept(fileName)
                self?.songURL.accept(url)
            case .failure(let error):
                Log.e(MoyangError.other(error))
            }
        }
    }
    
    private func checkAndSetIsNetworking() -> Bool {
        if isNetworking.value {
            Log.d("isNetworking...")
            return true
        }
        isNetworking.accept(true)
        return false
    }
    
    private func resetIsNetworking() {
        DispatchQueue.global().asyncAfter(deadline: .now() + .seconds(1)) {
            self.isNetworking.accept(false)
        }
    }
    
}
