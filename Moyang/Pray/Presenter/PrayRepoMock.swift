//
//  PrayRepoMock.swift
//  Moyang
//
//  Created by 정김기보 on 2022/01/01.
//

import Combine
import Foundation

class PrayRepoMock: PrayRepo {
    func add(_ pray: Pray) -> AnyPublisher<Bool, MoyangError> {
        return Empty(completeImmediately: false).eraseToAnyPublisher()
    }
    
    func fetchPraySubject() -> AnyPublisher<Pray, MoyangError> {
        return Empty(completeImmediately: false).eraseToAnyPublisher()
    }
    
    func addPraySubjectListListener() -> PassthroughSubject<[Pray], MoyangError> {
        let listener = PassthroughSubject<[Pray], MoyangError>()
        let list = DummyData().prayList

        DispatchQueue.global().asyncAfter(deadline: .now() + 0.1) {
            listener.send(list)
        }
        
        return listener
    }
}
