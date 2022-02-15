//
//  SermonRepo.swift
//  Moyang
//
//  Created by 정김기보 on 2022/02/10.
//

import Foundation
import Combine

protocol SermonRepo {
    func add(_ sermon: Sermon) -> AnyPublisher<Bool, MoyangError>
    func fetchSermonList() -> PassthroughSubject<[Sermon], MoyangError>
}
