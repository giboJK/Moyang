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
}

extension CommunityController: CommunityMainRepo {
    func fetchGroupInfo(community: String, groupID: String, completion: ((Result<GroupInfo, Error>) -> Void)?) {
        let ref = firestoreService.store
            .collection("COMMUNITY")
            .document(community)
            .collection("2022")
            .document(groupID)
        ref.addSnapshotListener { documentSnapshot, error in
            if let error = error {
                completion?(.failure(MoyangError.other(error)))
            }
            
            let decoder = JSONDecoder()
            if documentSnapshot?.data()?.isEmpty ?? true {
                completion?(.failure(MoyangError.emptyData))
            }
            if let dict = documentSnapshot?.data(),
               let data = try? JSONSerialization.data(withJSONObject: dict, options: []) {
                do {
                    let object = try decoder.decode(GroupInfo.self, from: data)
                    completion?(.success(object))
                } catch let error {
                    Log.e(error)
                }
            }
        }
    }
    
    func fetchGroupList() {
        
    }
    
}
