//
//  FirestoreService.swift
//  Moyang
//
//  Created by kibo on 2022/01/01.
//

import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseStorage
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
    
    func appendValueToList(value: Any,
                           key: String,
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
    
    func fetchDocumentsWithQuery<T: Codable>(query: Query,
                                             type: T.Type) -> AnyPublisher<[T], MoyangError>
}

protocol FSService {
    func addDocument<T: Codable>(_ object: T,
                                 ref: CollectionReference, completion: ((Result<Bool, MoyangError>) -> Void)?)
    func addDocument<T: Codable>(_ object: T,
                                 ref: DocumentReference, completion: ((Result<Bool, MoyangError>) -> Void)?)
    
    func addListener<T: Codable>(ref: CollectionReference,
                                 type: T.Type, completion: ((Result<T, MoyangError>) -> Void)?)
    
    func addListener<T: Codable>(ref: CollectionReference,
                                 type: T.Type, completion: ((Result<[T], MoyangError>) -> Void)?)
    
    func addListener<T: Codable>(ref: DocumentReference,
                                 type: T.Type, completion: ((Result<T, MoyangError>) -> Void)?)
    
    func fetchObject<T: Codable>(ref: CollectionReference,
                                 type: T.Type, completion: ((Result<T, MoyangError>) -> Void)?)
    
    func fetchObject<T: Codable>(ref: DocumentReference,
                                 type: T.Type, completion: ((Result<T, MoyangError>) -> Void)?)
    
    func fetchDocumentsWithQuery<T: Codable>(query: Query,
                                             type: T.Type, completion: ((Result<[T], MoyangError>) -> Void)?)
    
    func downloadFile(fileName: String, path: String, fileExt: String,
                      completion: ((Result<URL, MoyangError>) -> Void)?)
    
}

class FSServiceImplShared: FSService {
    
    deinit { Log.i(self) }
    
    var store = Firestore.firestore()
    
    func addDocument<T: Codable>(_ object: T, ref: CollectionReference, completion: ((Result<Bool, MoyangError>) -> Void)?) {
        Log.d(ref.path)
        do {
            _ = try ref.addDocument(from: object)
            completion?(.success(true))
        } catch {
            Log.e(error)
            completion?(.failure(MoyangError.writingFailed))
        }
    }
    
    func addDocument<T: Codable>(_ object: T, ref: DocumentReference, completion: ((Result<Bool, MoyangError>) -> Void)?) {
        Log.d(ref.path)
        do {
            _ = try ref.setData(from: object)
            completion?(.success(true))
        } catch {
            completion?(.failure(MoyangError.writingFailed))
        }
    }
    
    func addListener<T: Codable>(ref: CollectionReference,
                                 type: T.Type, completion: ((Result<T, MoyangError>) -> Void)?) {
        Log.d(ref.path)
        ref.addSnapshotListener { querySnapshot, error in
            if let error = error {
                completion?(.failure(.other(error)))
            }
            if let query = querySnapshot {
                let objectList = query.documents.compactMap { document in
                    try? document.data(as: T.self)
                }
                if let object = objectList.first {
                    completion?(.success(object))
                } else {
                    completion?(.failure(.decodingFailed))
                }
            } else {
                completion?(.failure(.emptyData))
            }
        }
    }
    
    func addListener<T: Codable>(ref: CollectionReference,
                                 type: T.Type, completion: ((Result<[T], MoyangError>) -> Void)?) {
        Log.d(ref.path)
        ref.addSnapshotListener { querySnapshot, error in
            if let error = error {
                completion?(.failure(.other(error)))
            }
            if let query = querySnapshot {
                let objectList = query.documents.compactMap { document in
                    try? document.data(as: T.self)
                }
                completion?(.success(objectList))
            } else {
                completion?(.failure(.decodingFailed))
            }
        }
    }
    
    func addListener<T: Codable>(ref: DocumentReference,
                                 type: T.Type, completion: ((Result<T, MoyangError>) -> Void)?) {
        Log.d(ref.path)
        ref.addSnapshotListener { documentSnapshot, error in
            if let error = error {
                completion?(.failure(.other(error)))
            }
            let decoder = JSONDecoder()
            if let dict = documentSnapshot?.data(),
               let data = try? JSONSerialization.data(withJSONObject: dict, options: []) {
                do {
                    let object = try decoder.decode(type, from: data)
                    completion?(.success(object))
                } catch let error {
                    completion?(.failure(.other(error)))
                }
            }
        }
    }
    
    func fetchObject<T: Codable>(ref: CollectionReference,
                                 type: T.Type, completion: ((Result<T, MoyangError>) -> Void)?) {
        Log.d(ref.path)
        ref.addSnapshotListener { querySnapshot, error in
            if let error = error {
                completion?(.failure(MoyangError.other(error)))
            }
            
            if let query = querySnapshot {
                let objectList = query.documents.compactMap { document in
                    try? document.data(as: T.self)
                }
                
                if let object = objectList.last {
                    completion?(.success(object))
                } else {
                    completion?(.failure(MoyangError.emptyData))
                }
            } else {
                completion?(.failure(MoyangError.decodingFailed))
            }
        }
    }
    
    func fetchObject<T: Codable>(ref: DocumentReference,
                                 type: T.Type, completion: ((Result<T, MoyangError>) -> Void)?) {
        Log.d(ref.path)
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
                    let object = try decoder.decode(type, from: data)
                    completion?(.success(object))
                } catch let error {
                    completion?(.failure(MoyangError.other(error)))
                }
            }
        }
    }
    
    func fetchDocumentsWithQuery<T: Codable>(query: Query,
                                             type: T.Type, completion: ((Result<[T], MoyangError>) -> Void)?) {
        Log.d(query)
        query.getDocuments { querySnapshot, error in
            if let error = error {
                completion?(.failure(MoyangError.other(error)))
            }
            if let querySnapshot = querySnapshot {
                if querySnapshot.documents.isEmpty {
                    completion?(.failure(MoyangError.emptyData))
                } else {
                    
                    let decoder = JSONDecoder()
                    var objectList = [T]()
                    querySnapshot.documents.forEach { queryDocumentSnapshot in
                        if let data = try? JSONSerialization.data(withJSONObject: queryDocumentSnapshot.data(), options: []) {
                            do {
                                let object = try decoder.decode(type, from: data)
                                objectList.append(object)
                            } catch let error {
                                completion?(.failure(MoyangError.other(error)))
                            }
                        }
                    }
                    completion?(.success(objectList))
                }
            }
        }
    }
    
    func downloadFile(fileName: String, path: String, fileExt: String, completion: ((Result<URL, MoyangError>) -> Void)?) {
        // Get a reference to the storage service using the default Firebase App
        let storage = Storage.storage()
        // Create a storage reference from our storage service
        let storageRef = storage.reference()
        
        let islandRef = storageRef.child("music/Road to God.mp3")
        
        // Create local filesystem URL
        let documentsUrl: URL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let localURL = documentsUrl.appendingPathComponent(path + "/" + fileName + "." + fileExt)
        
        // Download to the local filesystem
        _ = islandRef.write(toFile: localURL) { url, error in
            if let error = error {
                Log.e(url as Any)
                completion?(.failure(.other(error)))
            } else {
                Log.i("Success")
                completion?(.success(localURL))
            }
        }
    }
}
