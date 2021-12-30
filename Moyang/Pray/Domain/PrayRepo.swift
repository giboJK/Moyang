//
//  PrayRepo.swift
//  Moyang
//
//  Created by 정김기보 on 2021/10/11.
//  Copyright © 2021 정김기보. All rights reserved.
//

import Combine

protocol PrayRepo {
    func add(_ pray: PraySubject) -> AnyPublisher<Bool, MoyangError>
    
    func fetchPraySubject() -> AnyPublisher<PraySubject, MoyangError>
    
    func addPraySubjectListListener() -> PassthroughSubject<[PraySubject], MoyangError>
}
