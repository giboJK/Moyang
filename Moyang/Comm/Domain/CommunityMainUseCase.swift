//
//  CommunityMainUseCase.swift
//  Moyang
//
//  Created by 정김기보 on 2022/05/25.
//

import Foundation
import RxSwift
import RxCocoa

class CommunityMainUseCase {
    typealias PrayList = [GroupIndividualPray]
    let repo: CommunityMainRepo
    
    let groupInfo = BehaviorRelay<GroupInfo?>(value: nil)
    let cardMemberPrayList = BehaviorRelay<[(pray: GroupIndividualPray, member: Member)]>(value: [])
    let memberPrayList = BehaviorRelay<[(member: Member, list: PrayList)]>(value: [])
    let memberList = BehaviorRelay<[Member]>(value: [])
    let amenSuccess = BehaviorRelay<Void>(value: ())
    let reactionSuccess = BehaviorRelay<Void>(value: ())
    
    let songName = BehaviorRelay<String?>(value: nil)
    let songURL = BehaviorRelay<URL?>(value: nil)
    
    let isNetworking = BehaviorRelay<Bool>(value: false)
    
    let editingPraySuccess = BehaviorRelay<Void>(value: ())
    let editingPrayFailure = BehaviorRelay<Void>(value: ())
    
    let addingReplySuccess = BehaviorRelay<Void>(value: ())
    let addingReplyFailure = BehaviorRelay<Void>(value: ())
    
    let groupSummary = BehaviorRelay<GroupSummary?>(value: nil)
    let error = BehaviorRelay<MoyangError?>(value: nil)
    
    // MARK: - Lifecycle
    init(repo: CommunityMainRepo) {
        self.repo = repo
    }
    
    // MARK: - Function
    func fetchGroupSummary() {
        guard let myInfo = UserData.shared.userInfo else {
            Log.e("No user")
            return
        }
        
        repo.fetchGroupSummary(myInfo: myInfo) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                self.groupSummary.accept(data)
            case .failure(let error):
                Log.e(error)
                self.error.accept(.other(error))
            }
        }
    }
    func fetchGroupInfo() {
    }
    
    func fetchMemberIndividualPray(member: Member, groupID: String, limit: Int = 1, start: String) {
        if !memberList.value.contains(where: { $0.id == member.id }) {
            var list = memberList.value
            list.append(member)
            memberList.accept(list)
        }
        repo.fetchMemberIndividualPray(memberAuth: member.auth, email: member.email,
                                       groupID: groupID, limit: limit, start: start) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let groupIndividualPrayList):
                if let obj = groupIndividualPrayList.first {
                    var current = self.cardMemberPrayList.value
                    current.append((obj, member))
                    self.cardMemberPrayList.accept(current)
                }
            case .failure(let error):
                Log.e(error)
            }
        }
    }
    
    func fetchMemberIndividualPray(memberAuth: String, email: String, groupID: String, limit: Int = 1, start: String) {
        if checkAndSetIsNetworking() { return }
        var selectedList: (member: Member, list: CommunityMainUseCase.PrayList)?
        var selectedIndex: Array<(member: Member, list: CommunityMainUseCase.PrayList)>.Index!
        if let index = memberPrayList.value.firstIndex(where: { ($0.member.email == email) && ($0.member.auth == memberAuth) }) {
            selectedList = memberPrayList.value[index]
            selectedIndex = index
        }

        repo.fetchMemberIndividualPray(memberAuth: memberAuth, email: email,
                                       groupID: groupID, limit: limit, start: start) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(var data):
                var cur = self.memberPrayList.value
                if var selectedList = selectedList {
                    if selectedList.list.isEmpty {
                        selectedList.list = data
                    } else {
                        _ = data.removeFirst()
                        selectedList.list.append(contentsOf: data)
                    }
                    cur[selectedIndex] = selectedList
                    self.memberPrayList.accept(cur)
                } else {
                    let member = self.memberList.value.first(where: { ($0.email == email) && ($0.auth == memberAuth) })!
                    cur.append((member: member, list: data))
                    self.memberPrayList.accept(cur)
                }
            case .failure(let error):
                Log.e("\(memberAuth) - \(email) : \(error)")
            }
            self.resetIsNetworking()
        }
    }
    
    func clearPrayList() {
        memberPrayList.accept([])
    }
    func clearCardMemberPrayList() {
        cardMemberPrayList.accept([])
        memberPrayList.accept([])
    }
    
    func addIndividualPray(pray: String,
                           tags: [String],
                           isSecret: Bool) {
        repo.addPray(content: pray, tags: tags, isSecret: isSecret) { [weak self] result in
            switch result {
            case .success(let code):
                if code == 0 {
                    self?.editingPraySuccess.accept(())
                } else {
                    self?.editingPrayFailure.accept(())
                }
            case .failure(let error):
                Log.e(error)
                self?.editingPrayFailure.accept(())
            }
        }
    }
    
    func addReply(memberAuth: String,
                  email: String,
                  prayID: String,
                  reply: String,
                  date: String,
                  reactions: [PrayReaction] = [],
                  order: Int) {
        if checkAndSetIsNetworking() { return }
        var selectedList: (member: Member, list: CommunityMainUseCase.PrayList)?
        var selectedIndex: Array<(member: Member, list: CommunityMainUseCase.PrayList)>.Index!
        if let index = memberPrayList.value.firstIndex(where: { ($0.member.email == email) && ($0.member.auth == memberAuth) }) {
            selectedList = memberPrayList.value[index]
            selectedIndex = index
        }
        repo.addReply(memberAuth: memberAuth, email: email, prayID: prayID, reply: reply, date: date,
                      reactions: reactions, order: order) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let reply):
                if var selectedList = selectedList {
                    if let index = selectedList.list.firstIndex(where: { $0.prayID == prayID}) {
                        selectedList.list[index].replys.append(reply)
                        selectedList.list[index].latestDate = reply.createDate
                    }
                    var cur = self.memberPrayList.value
                    cur[selectedIndex] = selectedList
                    self.memberPrayList.accept(cur)
                }
                self.addingReplySuccess.accept(())
            case .failure(let error):
                Log.e(error)
                self.addingReplyFailure.accept(())
            }
            
            self.resetIsNetworking()
        }
    }
    
    func loadSong() {
        downloadSong()
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
    
    private func checkAndSetIsNetworking() -> Bool {
        if isNetworking.value { Log.d("isNetworking..."); return true }
        isNetworking.accept(true)
        return false
    }
    
    private func resetIsNetworking() {
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500)) {
            self.isNetworking.accept(false)
        }
    }
    
    func amen(time: Int, groupID: String) {
    }
}
