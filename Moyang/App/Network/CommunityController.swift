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
        fsShared.downloadFile(fileName: fileName, path: path, fileExt: fileExt, completion: completion)
    }
}
