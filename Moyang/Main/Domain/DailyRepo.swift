//
//  DailyRepo.swift
//  Moyang
//
//  Created by 정김기보 on 2021/12/11.
//

import Combine

protocol DailyRepo {
    func fetchDailyPreview() -> AnyPublisher<DailyPreview, MoyangError>
    
    // For firebase
    func addDailyPreviewListener() -> PassthroughSubject<DailyPreview, MoyangError>
    
    func addDailyPreview(_ data: DailyPreview) -> AnyPublisher<Bool, MoyangError>
}
