//
//  CommunityController.swift
//  Moyang
//
//  Created by 정김기보 on 2022/05/25.
//

import FirebaseFirestore
import FirebaseFirestoreSwift
import Foundation

class CommunityController {
    //    let networkService: NetworkServiceProtocol?
    let firestoreService: FirestoreService
    
    //    init(networkService: NetworkServiceProtocol) {
    //        self.networkService = networkService
    //    }
    init(firestoreService: FirestoreService) {
        self.firestoreService = firestoreService
    }
    let fsShared = FSServiceImplShared()
}

extension CommunityController: CommunityMainRepo {
    
    func fetchGroupInfo(community: String, groupID: String, completion: ((Result<GroupInfo, MoyangError>) -> Void)?) {
        let ref = firestoreService.store
            .collection("COMMUNITY")
            .document(community)
            .collection("2022")
            .document(groupID)
        fsShared.addListener(ref: ref, type: GroupInfo.self, completion: completion)
    }
    
    func fetchGroupList() {
        
    }
    
    func fetchMemberIndividualPray(memberAuth: String, email: String, groupID: String, limit: Int, start: String,
                                   completion: ((Result<[GroupIndividualPray], MoyangError>) -> Void)?) {
        let query = firestoreService.store
            .collection("USER")
            .document("AUTH")
            .collection(memberAuth)
            .document(email)
            .collection("PRAY")
            .whereField("group_id", in: [groupID])
            .order(by: "date", descending: true)
            .limit(to: limit)
            .start(at: [start])
        fsShared.fetchDocumentsWithQuery(query: query, type: GroupIndividualPray.self, completion: completion)
    }
    
    func fetchMemberNonSecretIndividualPray(memberAuth: String, email: String, groupID: String, limit: Int, start: String,
                                            completion: ((Result<[GroupIndividualPray], MoyangError>) -> Void)?) {
        let query = firestoreService.store
            .collection("USER")
            .document("AUTH")
            .collection(memberAuth)
            .document(email)
            .collection("PRAY")
            .whereField("group_id", in: [groupID])
            .whereField("is_secret", isEqualTo: false)
            .order(by: "date", descending: true)
            .limit(to: limit)
            .start(at: [start])
        fsShared.fetchDocumentsWithQuery(query: query, type: GroupIndividualPray.self, completion: completion)
        
    }
    
    func addIndividualPray(data: GroupIndividualPray, myInfo: MemberDetail, completion: ((Result<Bool, MoyangError>) -> Void)?) {
        let ref = firestoreService.store
            .collection("USER")
            .document("AUTH")
            .collection(myInfo.authType)
            .document(myInfo.email)
            .collection("PRAY")
            .document(data.id)
        
        fsShared.addDocument(data, ref: ref, completion: completion)
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
    
    func amen(time: Int, groupID: String, myInfo: MemberDetail, completion: ((Result<Bool, MoyangError>) -> Void)?) {
        let ref = firestoreService.store
            .collection("USER")
            .document("AUTH")
            .collection(myInfo.authType)
            .document(myInfo.email)
            .collection("PRAYRECORD")
            .document(groupID)
        let key = "amen_record"
        
        ref.updateData([
            key: FieldValue.arrayUnion([PrayTimeRecord(date: Date().toString("yyyy-MM-dd hh:mm"),
                                                       time: time).dict as Any])
        ]) { [weak self] error in
            if let error = error {
                Log.w(error)
                if error.localizedDescription.contains("No document") {
                    self?.addAmenRecord(time: time, groupID: groupID, myInfo: myInfo, completion: completion)
                } else {
                    completion?(.success(false))
                }
            } else {
                completion?(.success(true))
            }
        }
    }
    
    private func addAmenRecord(time: Int, groupID: String, myInfo: MemberDetail, completion: ((Result<Bool, MoyangError>) -> Void)?) {
        let ref = firestoreService.store
            .collection("USER")
            .document("AUTH")
            .collection(myInfo.authType)
            .document(myInfo.email)
            .collection("PRAYRECORD")
            .document(groupID)
        
        let data = PrayTimeRecordList(list: [PrayTimeRecord(date: Date().toString("yyyy-MM-dd hh:mm"),
                                                            time: time)])
        fsShared.addDocument(data, ref: ref, completion: completion)
    }
    
    func addReaction(memberAuth: String, email: String, prayID: String, myInfo: MemberDetail, reaction: String, reactions: [PrayReaction],
                     completion: ((Result<[PrayReaction], MoyangError>) -> Void)?) {
        let ref = firestoreService.store
            .collection("USER")
            .document("AUTH")
            .collection(memberAuth)
            .document(email)
            .collection("PRAY")
            .document(prayID)
        let key = "reactions"
        if let item = reactions.first(where: { $0.memberID == myInfo.id }) {
            ref.updateData([
                key: FieldValue.arrayRemove([item.dict as Any])
            ]) { error in
                if let error = error {
                    Log.w(error)
                } else {
                    ref.updateData([
                        key: FieldValue.arrayUnion([PrayReaction(memberID: myInfo.id,
                                                                 reaction: reaction).dict as Any])
                    ]) { error in
                        if let error = error {
                            Log.w(error)
                        } else {
                            var changed = reactions
                            if let index = reactions.firstIndex(where: { $0.memberID == myInfo.id }) {
                                changed[index].reaction = reaction
                            }
                            completion?(.success(changed))
                        }
                    }
                }
            }
        } else {
            ref.updateData([
                key: FieldValue.arrayUnion([PrayReaction(memberID: myInfo.id,
                                                         reaction: reaction).dict as Any])
            ]) { error in
                if let error = error {
                    Log.w(error)
                } else {
                    var changed = reactions
                    changed.append(PrayReaction(memberID: myInfo.id,
                                                reaction: reaction))
                    completion?(.success(changed))
                }
            }
        }
    }
    func addReply(memberAuth: String, email: String, prayID: String, reply: String, date: String, reactions: [PrayReaction], order: Int,
                  completion: ((Result<PrayReply, MoyangError>) -> Void)?) {
        let ref = firestoreService.store
            .collection("USER")
            .document("AUTH")
            .collection(memberAuth)
            .document(email)
            .collection("PRAY")
            .document(prayID)
        guard let myInfo = UserData.shared.myInfo else { Log.e(""); return }
        let key = "replys"
        let item = PrayReply(memberID: myInfo.id,
                             reply: reply,
                             date: date,
                             reactions: [],
                             order: order)
        ref.updateData([
            key: FieldValue.arrayUnion([item.dict as Any])
        ]) { error in
            if let error = error {
                Log.w(error)
                completion?(.failure(.writingFailed))
            } else {
                completion?(.success(item))
            }
        }
    }
}

extension CommunityController: GroupPrayRepo {
    func editPray(myInfo: MemberDetail, prayID: String, pray: String, tags: [String], isSecret: Bool, isRequestPray: Bool,
                  completion: ((Result<Bool, MoyangError>) -> Void)?) {
        let ref = firestoreService.store
            .collection("USER")
            .document("AUTH")
            .collection(myInfo.authType)
            .document(myInfo.email)
            .collection("PRAY")
            .document(prayID)
        
        ref.updateData(["pray": pray,
                        "tags": tags,
                        "is_secret": isSecret,
                        "is_request_pray": isRequestPray]) { error in
            if let error = error {
                Log.e(error)
                completion?(.success(false))
            } else {
                completion?(.success(true))
            }
        }
    }
}
