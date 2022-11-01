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
    
    // MARK: - GroupPray
    let myPrayList = BehaviorRelay<[MyPray]>(value: [])
    let memberPrayList = BehaviorRelay<[String: [MyPray]]>(value: [:])
    let autoCompleteList = BehaviorRelay<[String]>(value: [])
    let searchedPrayList = BehaviorRelay<[SearchedPray]>(value: [])
    
    let hasAmenDict = BehaviorRelay<[String: Set<String>]>(value: [:])
    let hasPrayDict = BehaviorRelay<[String: Set<String>]>(value: [:])
    // MARK: - Event
    let addNewPraySuccess = BehaviorRelay<Void>(value: ())
    let addNewPrayFailure = BehaviorRelay<Void>(value: ())
    let updatePraySuccess = BehaviorRelay<Void>(value: ())
    let updatePrayFailure = BehaviorRelay<Void>(value: ())
    let fetchPraySuccess = BehaviorRelay<MyPray?>(value: nil)
    let fetchPrayFailure = BehaviorRelay<Void>(value: ())
    
    let plusPraySuccess = BehaviorRelay<Void>(value: ())
    let plusPrayFailure = BehaviorRelay<Void>(value: ())
    
    let addChangeSuccess = BehaviorRelay<Void>(value: ())
    let addChangeFailure = BehaviorRelay<Void>(value: ())
    
    let addReplySuccess = BehaviorRelay<Void>(value: ())
    let addReplyFailure = BehaviorRelay<Void>(value: ())
    
    let deleteReplySuccess = BehaviorRelay<Void>(value: ())
    let deleteReplyFailure = BehaviorRelay<Void>(value: ())
    let updateReplySuccess = BehaviorRelay<Void>(value: ())
    let updateReplyFailure = BehaviorRelay<Void>(value: ())
    
    let addAnswerSuccess = BehaviorRelay<Void>(value: ())
    let addAnswerFailure = BehaviorRelay<Void>(value: ())
    
    let deletePraySuccess = BehaviorRelay<Void>(value: ())
    let deletePrayFailure = BehaviorRelay<Void>(value: ())
    
    // MARK: - GroupPraying
    let songName = BehaviorRelay<String?>(value: nil)
    let songURL = BehaviorRelay<URL?>(value: nil)
    
    let amenSuccess = BehaviorRelay<Void>(value: ())
    let amenFailure = BehaviorRelay<Void>(value: ())
    
    // MARK: - Default events
    let isNetworking = BehaviorRelay<Bool>(value: false)
    let isSuccess = BehaviorRelay<Void>(value: ())
    let isFailure = BehaviorRelay<Void>(value: ())
    
    let userIDNameDict = BehaviorRelay<[String: String]>(value: [:])
    private var userPrayFetchDate = [String: Set<String>]() // 유저별로 해당 날짜의 기도를 불러온 적이 있는지 저장하는 모델
    
    // MARK: - Lifecycle
    init(repo: MyPrayRepo) {
        self.repo = repo
    }
    
    // MARK: - Function
    func addPray(pray: String, tags: [String], isSecret: Bool) {
        guard let groupID = UserData.shared.groupInfo?.id else { Log.e("No group ID"); return }
        guard let myID = UserData.shared.userInfo?.id else { Log.e("No user ID"); return }
        if checkAndSetIsNetworking() { return }
        repo.addPray(userID: myID,
                     groupID: groupID,
                     content: pray,
                     tags: tags,
                     isSecret: isSecret) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                if response.code == 0 {
                    self.addNewPraySuccess.accept(())
                    var curList = self.myPrayList.value
                    curList.insert(response.data, at: 0)
                    self.myPrayList.accept(curList)
                } else {
                    self.addNewPrayFailure.accept(())
                }
            case .failure(let error):
                Log.e(error)
                self.addNewPrayFailure.accept(())
            }
            self.resetIsNetworking()
        }
    }
    
    func updatePray(prayID: String, pray: String, tags: [String], isSecret: Bool) {
        if checkAndSetIsNetworking() { return }
        guard let myID = UserData.shared.userInfo?.id else {
            updatePrayFailure.accept(()); return
        }
        repo.updatePray(prayID: prayID,
                        pray: pray,
                        tags: tags,
                        isSecret: isSecret) { [weak self] result in
            switch result {
            case .success(let response):
                if response.code == 0 {
                    self?.updatePraySuccess.accept(())
                    self?.updatePray(userID: myID, prayID: prayID, pray: pray, tags: tags, isSecret: isSecret)
                } else {
                    self?.updatePrayFailure.accept(())
                }
            case .failure(let error):
                Log.e(error)
                self?.addNewPrayFailure.accept(())
            }
            self?.resetIsNetworking()
        }
    }
    
    func fetchPrayList(userID: String, order: String, page: Int, row: Int = 7) {
        guard let groupID = UserData.shared.groupInfo?.id else { Log.e("No group ID"); return }
        guard let myID = UserData.shared.userInfo?.id else { Log.e("No user ID"); return }
        if checkAndSetIsNetworking() {
            return
        }
        let isMe = userID == myID
        repo.fetchPrayList(groupID: groupID, userID: userID, isMe: isMe, order: order, page: page, row: row) { [weak self] result in
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
    
    func deletePray(prayID: String) {
        guard let myID = UserData.shared.userInfo?.id else { Log.e("No user ID"); return }
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
    func updateReply(replyID: String, reply: String, userID: String, prayID: String) {
        repo.updateReply(replyID: replyID, reply: reply) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                if response.code == 0 {
                    self.updateReplySuccess.accept(())
                    var dict = self.memberPrayList.value
                    if var curList = dict[userID] {
                        if let index = curList.firstIndex(where: { $0.prayID == prayID }) {
                            if let replyIndex = curList[index].replys.firstIndex(where: { $0.id == replyID}) {
                                curList[index].replys[replyIndex].reply = reply
                            }
                        }
                        dict.updateValue(curList, forKey: userID)
                        self.memberPrayList.accept(dict)
                    }
                } else {
                    self.updateReplyFailure.accept(())
                }
            case .failure(let error):
                Log.e(error)
                self.updateReplyFailure.accept(())
            }
        }
    }
    func deleteReply(replyID: String, userID: String, prayID: String) {
        if checkAndSetIsNetworking() { return }
        repo.deleteReply(replyID: replyID) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                if response.code == 0 {
                    self.deleteReplySuccess.accept(())
                    var dict = self.memberPrayList.value
                    if var curList = dict[userID] {
                        if let index = curList.firstIndex(where: { $0.prayID == prayID }) {
                            curList[index].replys.removeAll { $0.id == replyID }
                        }
                        dict.updateValue(curList, forKey: userID)
                        self.memberPrayList.accept(dict)
                    }
                } else {
                    self.deleteReplyFailure.accept(())
                }
            case .failure(let error):
                Log.e(error)
                self.deleteReplyFailure.accept(())
            }
            self.resetIsNetworking()
        }
    }
    
    func addReaction(userID: String, prayID: String, type: Int) {
        guard let myID = UserData.shared.userInfo?.id else { Log.e("No user ID"); return }
        if checkAndSetIsNetworking() { return }
        repo.addReaction(userID: myID, prayID: prayID, type: type) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                if response.code == 0 {
                    self.isSuccess.accept(())
                    var dict = self.memberPrayList.value
                    if var curList = dict[userID] {
                        if let index = curList.firstIndex(where: { $0.prayID == prayID }) {
                            curList[index].reactions.removeAll { $0.userID == myID }
                            curList[index].reactions.append(response.data)
                            dict.updateValue(curList, forKey: userID)
                            self.memberPrayList.accept(dict)
                        }
                    }
                } else {
                    Log.e("")
                    self.isFailure.accept(())
                }
            case .failure(let error):
                Log.e(error)
                self.isFailure.accept(())
            }
            self.resetIsNetworking()
        }
    }
    
    func addAnswer(prayID: String, answer: String) {
        guard let myID = UserData.shared.userInfo?.id else { Log.e("No user ID"); return }
        if checkAndSetIsNetworking() { return }
        repo.addAnswer(userID: myID, prayID: prayID, answer: answer) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                if response.code == 0 {
                    self.addAnswerSuccess.accept(())
                    var dict = self.memberPrayList.value
                    if var curList = dict[myID] {
                        if let index = curList.firstIndex(where: { $0.prayID == prayID }) {
                            curList[index].answers.append(response.data)
                            dict.updateValue(curList, forKey: myID)
                            self.memberPrayList.accept(dict)
                        }
                    }
                } else {
                    Log.e("")
                    self.addAnswerFailure.accept(())
                }
            case .failure(let error):
                Log.e(error)
                self.addAnswerFailure.accept(())
            }
            self.resetIsNetworking()
        }
    }
    
    func addReply(userID: String, prayID: String, reply: String) {
        guard let myID = UserData.shared.userInfo?.id else { Log.e("No user ID"); return }
        if checkAndSetIsNetworking() { return }
        repo.addReply(userID: myID, prayID: prayID, reply: reply) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                if response.code == 0 {
                    self.addReplySuccess.accept(())
                    var dict = self.memberPrayList.value
                    if var curList = dict[userID] {
                        if let index = curList.firstIndex(where: { $0.prayID == prayID }) {
                            curList[index].replys.append(response.data)
                            dict.updateValue(curList, forKey: userID)
                            self.memberPrayList.accept(dict)
                        }
                    }
                } else {
                    Log.e("")
                    self.addReplyFailure.accept(())
                }
            case .failure(let error):
                Log.e(error)
                self.addReplyFailure.accept(())
            }
            self.resetIsNetworking()
        }
    }
    
    func addChange(prayID: String, content: String) {
        guard let myID = UserData.shared.userInfo?.id else { Log.e("No user ID"); return }
        if checkAndSetIsNetworking() { return }
        repo.addChange(prayID: prayID, content: content) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                if response.code == 0 {
                    self.addChangeSuccess.accept(())
                    var dict = self.memberPrayList.value
                    if var curList = dict[myID] {
                        if let index = curList.firstIndex(where: { $0.prayID == prayID }) {
                            curList[index].changes.append(response.data)
                            dict.updateValue(curList, forKey: myID)
                            self.memberPrayList.accept(dict)
                        }
                    }
                } else {
                    Log.e("")
                    self.addChangeFailure.accept(())
                }
            case .failure(let error):
                Log.e(error)
                self.addChangeFailure.accept(())
            }
            self.resetIsNetworking()
        }
    }
    
    func addAmen(groupID: String, time: Int) {
        guard let myID = UserData.shared.userInfo?.id else { Log.e("No user ID"); return }
        if checkAndSetIsNetworking() { return }
        repo.addAmen(userID: myID, groupID: groupID, time: time) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                if response.code == 0 {
                    self.amenSuccess.accept(())
                } else {
                    Log.e("")
                    self.amenFailure.accept(())
                }
            case .failure(let error):
                Log.e(error)
                self.amenFailure.accept(())
            }
            self.resetIsNetworking()
        }
    }
    
    func fetchGroupAcitvity(groupID: String, isWeek: Bool, date: String) {
        let amenDict = self.hasAmenDict.value
        if let start = date.toDate("yyyy-MM-dd hh:mm:ss Z") {
            if amenDict[start.toString("yyyy-MM-dd")] != nil {
                Log.d("Has data")
                return
            }
        }
        repo.fetchGroupAcitvity(groupID: groupID, isWeek: isWeek, date: date) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                if response.code == 0 {
                    var amenDict = self.hasAmenDict.value
                    var prayDict = self.hasPrayDict.value
                    if isWeek {
                        if let start = date.toDate("yyyy-MM-dd hh:mm:ss Z"),
                           let end = start.endOfWeek {
                            let dayDiff = Calendar.current.numberOfDaysBetween(start, and: end)
                            for i in 0 ..< dayDiff {
                                let keyDate = start.addDays(i)
                                amenDict.updateValue(Set<String>(), forKey: keyDate.toString("yyyy-MM-dd"))
                                prayDict.updateValue(Set<String>(), forKey: keyDate.toString("yyyy-MM-dd"))
                            }
                        }
                    } else { // month
                        if let start = date.toDate("yyyy-MM-dd hh:mm:ss Z"),
                           let end = start.endOfMonth {
                            let dayDiff = Calendar.current.numberOfDaysBetween(start, and: end)
                            for i in 0 ..< dayDiff {
                                let keyDate = start.addDays(i)
                                amenDict.updateValue(Set<String>(), forKey: keyDate.toString("yyyy-MM-dd"))
                                prayDict.updateValue(Set<String>(), forKey: keyDate.toString("yyyy-MM-dd"))
                            }
                        }
                    }
                    self.hasPrayDict.accept(prayDict)
                } else {
                    Log.e("")
                }
            case .failure(let error):
                Log.e(error)
            }
            self.resetIsNetworking()
        }
    }
    
    func fetchAutocompleteList(keyword: String) {
        repo.fetchTagAutocomplete(tag: keyword) { [weak self] result in
            switch result {
            case .success(let response):
                self?.autoCompleteList.accept(response.tags.map { $0.content })
            case .failure(let error):
                Log.e(error)
            }
            
        }
    }
    
    func searchWithKeyword(keyword: String, groupID: String) {
        repo.searchPrays(tag: keyword, groupID: groupID) { [weak self] result in
            switch result {
            case .success(let response):
                self?.searchedPrayList.accept(response.prays.sorted(by: { $0.latestDate > $1.latestDate }))
            case .failure(let error):
                Log.e(error)
            }
        }
    }
    
    func removeAutoCompleteList() {
        autoCompleteList.accept([])
    }
    
    
    func fetchPray(prayID: String, userID: String) {
        repo.fetchPray(prayID: prayID) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let pray):
                self.fetchPraySuccess.accept(pray)
                var dict = self.memberPrayList.value
                if var curList = dict[userID] {
                    if curList.contains(where: { $0.prayID == pray.prayID }) {
                        return
                    }
                    curList.append(pray)
                    curList.sort { $0.latestDate < $1.latestDate }
                    dict.updateValue(curList, forKey: userID)
                    self.memberPrayList.accept(dict)
                }
            case .failure(let error):
                Log.e(error)
                self.fetchPrayFailure.accept(())
            }
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
    
    private func updatePray(userID: String, prayID: String, pray: String, tags: [String], isSecret: Bool) {
        if var list = memberPrayList.value[userID] {
            if let index = list.firstIndex(where: { $0.prayID == prayID }) {
                list[index].pray = pray
                list[index].tags = tags
                list[index].isSecret = isSecret
                var dict = memberPrayList.value
                dict.updateValue(list, forKey: userID)
                memberPrayList.accept(dict)
            }
        }
    }
}
