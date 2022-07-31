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
    let networkService: NetworkServiceProtocol
    let fsShared = FSServiceImplShared()
    
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }
}

extension CommunityController: CommunityMainRepo {
    func fetchGroupSummary(myInfo: UserInfo, completion: ((Result<GroupSummary, MoyangError>) -> Void)?) {
        let url = networkService.makeUrl(path: NetConst.GroupAPI.fetchGroupSummary)
        let dict = ["user_id": myInfo.id]
        let request = networkService.makeRequest(url: url,
                                                 method: .post,
                                                 parameters: dict)
        networkService.requestAPI(request: request,
                                  type: GroupSummary.self,
                                  token: nil) { result in
            switch result {
            case .success(let response):
                completion?(.success(response))
            case .failure(let error):
                completion?(.failure(.other(error)))
            }
        }
    }
    
    func fetchGroupInfo(community: String, groupID: String, completion: ((Result<GroupInfo, MoyangError>) -> Void)?) {
//        let ref = firestoreService.store
//            .collection("COMMUNITY")
//            .document(community)
//            .collection("2022")
//            .document(groupID)
//        fsShared.addListener(ref: ref, type: GroupInfo.self, completion: completion)
    }
    
    func fetchMemberIndividualPray(memberAuth: String, email: String, groupID: String, limit: Int, start: String,
                                   completion: ((Result<[GroupIndividualPray], MoyangError>) -> Void)?) {
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
    
    func addReply(memberAuth: String, email: String, prayID: String, reply: String, date: String, reactions: [PrayReaction], order: Int,
                  completion: ((Result<PrayReply, MoyangError>) -> Void)?) {
//        let ref = firestoreService.store
//            .collection("USER")
//            .document("AUTH")
//            .collection(memberAuth)
//            .document(email)
//            .collection("PRAY")
//            .document(prayID)
//        guard let myInfo = UserData.shared.myInfo else { Log.e(""); return }
//        let key = "replys"
//        let item = PrayReply(memberID: myInfo.id,
//                             reply: reply,
//                             date: date,
//                             reactions: [],
//                             order: order)
//        ref.updateData([
//            key: FieldValue.arrayUnion([item.dict as Any]),
//            "date": date
//        ]) { error in
//            if let error = error {
//                Log.w(error)
//                completion?(.failure(.writingFailed))
//            } else {
//                completion?(.success(item))
//            }
//        }
    }
}

extension CommunityController: GroupPrayRepo {
    func editPray() {
    }
}

extension CommunityController: AllGroupRepo {
    func fetchGroupList() {
        
    }
}
