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

// 2
class PrayRepo: ObservableObject {
    // 3
    private let path: String = "cards"
    // 4
    private let store = Firestore.firestore()
    
    // 5
    func add(_ pray: PraySubject) {
        do {
            // 6
            _ = try store.collection(path).addDocument(from: pray)
        } catch {
            fatalError("Unable to add card: \(error.localizedDescription).")
        }
    }
}
