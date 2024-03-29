//
//  MyPrayUseCase.swift
//  Moyang
//
//  Created by 정김기보 on 2022/06/28.
//

import Foundation
import RxSwift
import RxCocoa

class MyPrayUseCase: UseCase {
    let repo: MyPrayRepo
    
    // MARK: - MyPray
    let myPraySummary = BehaviorRelay<MyPraySummary?>(value: nil)
    let myPrayList = BehaviorRelay<[MyPray]>(value: [])
    let myGroupList = BehaviorRelay<[MyGroup]>(value: [])
    let prayDetail = BehaviorRelay<PrayDetail?>(value: nil)
    
    // MARK: - Event
    let addPraySuccess = BehaviorRelay<Void>(value: ())
    let addPrayFailure = BehaviorRelay<Void>(value: ())
    let updatePraySuccess = BehaviorRelay<Void>(value: ())
    let updatePrayFailure = BehaviorRelay<Void>(value: ())
    let deletePraySuccess = BehaviorRelay<Void>(value: ())
    let deletePrayFailure = BehaviorRelay<Void>(value: ())
    
    /// Change & Answer
    let addChangeSuccess = BehaviorRelay<Void>(value: ())
    let addChangeFailure = BehaviorRelay<Void>(value: ())
    let addAnswerSuccess = BehaviorRelay<Void>(value: ())
    let addAnswerFailure = BehaviorRelay<Void>(value: ())
    
    // MyPrayFixVC
    let updateChangeSuccess = BehaviorRelay<Void>(value: ())
    let updateChangeFailure = BehaviorRelay<Void>(value: ())
    let updateAnswerSuccess = BehaviorRelay<Void>(value: ())
    let updateAnswerFailure = BehaviorRelay<Void>(value: ())
    
    
    // MARK: - GroupPraying
    let songName = BehaviorRelay<String?>(value: nil)
    let songURL = BehaviorRelay<URL?>(value: nil)
    
    
    init(repo: MyPrayRepo) {
        self.repo = repo
    }
    
    // MARK: - Add
    func addPray(title: String, content: String, groupID: String) {
        guard let myID = UserData.shared.userInfo?.id else { Log.e("No user ID"); return }
        if checkAndSetIsNetworking() { return }
        repo.addPray(userID: myID,
                     category: title,
                     content: content,
                     groupID: groupID) { [weak self] result in
            self?.resetIsNetworking()
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
        }
    }
    
    func addAnswer(answer: String) {
        guard let prayID = prayDetail.value?.prayID else { Log.e("No pray ID"); return }
        addAnswer(prayID: prayID, answer: answer)
    }
    
    func addChange(change: String) {
        guard let prayID = prayDetail.value?.prayID else { Log.e("No pray ID"); return }
        addChange(prayID: prayID, change: change)
    }
    
    private func addAnswer(prayID: String, answer: String) {
        if checkAndSetIsNetworking() { return }
        repo.addAnswer(prayID: prayID, answer: answer) { [weak self] result in
            self?.resetIsNetworking()
            guard let self = self else { return }
            switch result {
            case .success(let response):
                if response.code == 0 {
                    self.addAnswerSuccess.accept(())
                    var cur = self.prayDetail.value!
                    cur.answers.append(response.data)
                    self.prayDetail.accept(cur)
                } else {
                    self.addAnswerFailure.accept(())
                    Log.e(response.errorMessage ?? "")
                }
            case .failure(let error):
                Log.e(error)
                self.addAnswerFailure.accept(())
            }
        }
    }
    
    private func addChange(prayID: String, change: String) {
        if checkAndSetIsNetworking() { return }
        repo.addChange(prayID: prayID, change: change) { [weak self] result in
            self?.resetIsNetworking()
            guard let self = self else { return }
            switch result {
            case .success(let response):
                if response.code == 0 {
                    self.addChangeSuccess.accept(())
                    var cur = self.prayDetail.value!
                    cur.changes.append(response.data)
                    self.prayDetail.accept(cur)
                } else {
                    self.addChangeFailure.accept(())
                    Log.e(response.errorMessage ?? "")
                }
            case .failure(let error):
                Log.e(error)
                self.addChangeFailure.accept(())
            }
        }
    }
    
    func addPrayGroupInfo(groupID: String, prayID: String) {
        
    }
    
    // MARK: - Fetch
    func fetchSummary(date: String) {
        guard let myID = UserData.shared.userInfo?.id else { Log.e("No user ID"); return }
        if checkAndSetIsNetworking() { return }
        repo.fetchSummary(userID: myID, date: date) { [weak self] result in
            self?.resetIsNetworking()
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
        }
    }
    
    // TODO: - 네트워크 사용 줄이기 위해 Main과 UseCase를 공유하도록 변경하고 Scroll down to refresh를 추가하자..
    func fetchPrayList(userID: String, page: Int, row: Int = 7) {
        if checkAndSetIsNetworking() {
            return
        }
        repo.fetchPrayList(userID: userID, page: page, row: row) { [weak self] result in
            self?.resetIsNetworking()
            guard let self = self else { return }
            switch result {
            case .success(let list):
                var cur = self.myPrayList.value
                if cur.isEmpty {
                    self.myPrayList.accept(list)
                } else {
                    for item in list {
                        if !cur.contains(where: { $0.prayID == item.prayID }) {
                            cur.append(item)
                        }
                    }
                    self.myPrayList.accept(cur)
                }
            case .failure(let error):
                Log.e(error)
            }
        }
    }
    
    func fetchMorePrayList(userID: String) {
        let page = myPrayList.value.count
        fetchPrayList(userID: userID, page: page)
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
    
    func fetchPrayDetail(prayID: String) {
        if checkAndSetIsNetworking() { return }
        repo.fetchPrayDetail(prayID: prayID) { [weak self] result in
            self?.resetIsNetworking()
            switch result {
            case .success(let response):
                if response.code == 0 {
                    self?.prayDetail.accept(response.data)
                } else {
                    Log.e("")
                }
            case .failure(let error):
                Log.e(error)
            }
        }
    }
    
    
    // MARK: - Update
    func updatePray(category: String, content: String, groupID: String) {
        guard let prayID = prayDetail.value?.prayID else {
            Log.e("No pray id"); return
        }
        updatePray(prayID: prayID, category: category, content: content, groupID: groupID)
    }
    private func updatePray(prayID: String, category: String, content: String, groupID: String) {
        if checkAndSetIsNetworking() { return }
        repo.updatePray(prayID: prayID, category: category, content: content, groupID: groupID) { [weak self] result in
            self?.resetIsNetworking()
            guard let self = self else { return }
            switch result {
            case .success(let response):
                if response.code == 0 {
                    var cur = self.prayDetail.value
                    cur?.category = category
                    
                    if let group = self.myGroupList.value.first(where: { $0.id == groupID }) {
                        cur?.groupID = groupID
                        cur?.groupName = group.name
                    } else {
                        cur?.groupID = nil
                        cur?.groupName = nil
                    }
                    cur?.content = content
                    self.prayDetail.accept(cur)
                    self.updatePraySuccess.accept(())
                } else {
                    self.updatePrayFailure.accept(())
                }
            case .failure(let error):
                Log.e(error)
                self.addPrayFailure.accept(())
            }
        }
    }
    
    func updateChange(changeID: String, change: String) {
        if checkAndSetIsNetworking() { return }
        repo.updateChange(changeID: changeID, change: change) { [weak self] result in
            self?.resetIsNetworking()
            guard let self = self else { return }
            switch result {
            case .success(let response):
                if response.code == 0 {
                    var cur = self.prayDetail.value!
                    var changes = cur.changes
                    if let index = changes.firstIndex(where: { $0.id == changeID }) {
                        changes[index].content = change
                        cur.changes = changes
                    }
                    self.prayDetail.accept(cur)
                    self.updateChangeSuccess.accept(())
                } else {
                    self.updateChangeFailure.accept(())
                }
            case .failure(let error):
                Log.e(error)
                self.updateChangeFailure.accept(())
            }
        }
    }
    
    func updateAnswer(answerID: String, answer: String) {
        if checkAndSetIsNetworking() { return }
        repo.updateAnswer(answerID: answerID, answer: answer) { [weak self] result in
            self?.resetIsNetworking()
            guard let self = self else { return }
            switch result {
            case .success(let response):
                if response.code == 0 {
                    var cur = self.prayDetail.value!
                    var answers = cur.answers
                    if let index = answers.firstIndex(where: { $0.id == answerID }) {
                        answers[index].answer = answer
                        cur.answers = answers
                    }
                    self.prayDetail.accept(cur)
                    self.updateAnswerSuccess.accept(())
                } else {
                    self.updateAnswerFailure.accept(())
                }
            case .failure(let error):
                Log.e(error)
                self.updateAnswerFailure.accept(())
            }
        }
    }
    
    // MARK: - Delete
    func deletePray(prayID: String) {
        if checkAndSetIsNetworking() { return }
        repo.deletePray(prayID: prayID) { [weak self] result in
            self?.resetIsNetworking()
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
        }
    }
    
    func deletePray() {
        if let prayID = prayDetail.value?.prayID {
            deletePray(prayID: prayID)
        } else {
            deletePrayFailure.accept(())
        }
    }
    
    func deleteAnswer(answewrID: String) {
        if checkAndSetIsNetworking() { return }
        repo.deleteAnswer(answerID: answewrID) { [weak self] result in
            self?.resetIsNetworking()
            switch result {
            case .success(let response):
                if response.code == 0 {
                    var cur = self?.prayDetail.value!
                    var answers = cur!.answers
                    answers.removeAll { $0.id == answewrID }
                    cur?.answers = answers
                    self?.prayDetail.accept(cur)
                } else {
                    
                }
            case .failure(let error):
                Log.e(error)
            }
        }
    }
    
    func deleteChange(changeID: String) {
        if checkAndSetIsNetworking() { return }
        repo.deleteChange(changeID: changeID) { [weak self] result in
            self?.resetIsNetworking()
            switch result {
            case .success(let response):
                if response.code == 0 {
                    var cur = self?.prayDetail.value!
                    var changes = cur!.changes
                    changes.removeAll { $0.id == changeID }
                    cur?.changes = changes
                    self?.prayDetail.accept(cur)
                } else {
                    
                }
            case .failure(let error):
                Log.e(error)
            }
        }
    }
    
    
    // MARK: - Firestore
    func loadSong() {
        downloadSong()
    }
    
    
    // MARK: - Local function
    func setPrayDeatail(groupID: String?, groupName: String?) {
        if let myPray = self.myPrayList.value.first {
            prayDetail.accept(PrayDetail(myPray: myPray, groupID: groupID, groupName: groupName))
        } else {
            Log.e("")
        }
    }
    
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
}
