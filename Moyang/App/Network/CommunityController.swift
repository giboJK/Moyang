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
    
    func fetchMemberIndividualPray(member: Member, groupID: String, limit: Int, completion: ((Result<[GroupIndividualPray], MoyangError>) -> Void)?) {
        let query = firestoreService.store
            .collection("USER")
            .document("AUTH")
            .collection(member.auth!)
            .document(member.email)
            .collection("PRAY")
            .whereField("group_id", in: [groupID])
            .order(by: "date", descending: true)
            .limit(to: limit)
        fsShared.fetchDocumentsWithQuery(query: query, type: GroupIndividualPray.self, completion: completion)
    }
}
