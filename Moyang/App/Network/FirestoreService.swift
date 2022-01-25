//
//  FirestoreService.swift
//  Moyang
//
//  Created by kibo on 2022/01/01.
//

import FirebaseFirestore
import FirebaseFirestoreSwift
import Combine

protocol FirestoreService {
    var store: Firestore { get }
    
    func addDocument<T: Codable>(_ object: T,
                                 ref: CollectionReference) -> AnyPublisher<Bool, MoyangError>
    
    func addDocument<T: Codable>(_ object: T,
                                 ref: DocumentReference) -> AnyPublisher<Bool, MoyangError>
    
    func updateDocument<T: Codable>(_ object: T,
                                    ref: DocumentReference) -> AnyPublisher<Bool, MoyangError>
    
    func updateDocument(value: [String: Any],
                        ref: DocumentReference) -> AnyPublisher<Bool, MoyangError>
    
    func addListener<T: Codable>(ref: CollectionReference,
                                 type: T.Type) -> PassthroughSubject<T, MoyangError>
    
    func addListener<T: Codable>(ref: CollectionReference,
                                 type: T.Type) -> PassthroughSubject<[T], MoyangError>
    
    func addListener<T: Codable>(ref: DocumentReference,
                                 type: T.Type) -> PassthroughSubject<T, MoyangError>
    
    func fetchObject<T: Codable>(ref: CollectionReference,
                                 type: T.Type) -> AnyPublisher<T, MoyangError>
    
    func fetchObject<T: Codable>(ref: DocumentReference,
                                 type: T.Type) -> AnyPublisher<T, MoyangError>
}
