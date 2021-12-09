//
//  PrayRepo.swift
//  Moyang
//
//  Created by 정김기보 on 2021/10/11.
//  Copyright © 2021 정김기보. All rights reserved.
//
// 1
import FirebaseFirestore
import FirebaseFirestoreSwift
import Combine

class PrayRepo: ObservableObject {
    private let path: String = "PRAY_SUBJECT"
    private let store = Firestore.firestore()
    
    @Published var prays: [PraySubject] = []
    
    init() {
        get()
    }
    
    func add(_ pray: PraySubject) {
        do {
            _ = try store.collection(path).addDocument(from: pray)
        } catch {
            fatalError("Unable to add card: \(error.localizedDescription).")
        }
    }
    
    func get() {
        store.collection(path)
            .addSnapshotListener { querySnapshot, error in
                if let error = error {
                    Log.e("Error getting cards: \(error.localizedDescription)")
                    return
                }
                
                self.prays = querySnapshot?.documents.compactMap { document in
                    try? document.data(as: PraySubject.self)
                } ?? []
            }
    }
    
}
