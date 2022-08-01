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

protocol FSService {
    func downloadFile(fileName: String, path: String, fileExt: String,
                      completion: ((Result<URL, MoyangError>) -> Void)?)
}

class FSServiceImplShared: FSService {
    
    deinit { Log.i(self) }
    
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
