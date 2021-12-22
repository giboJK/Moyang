//
//  SummaryRepo.swift
//  Moyang
//
//  Created by 정김기보 on 2021/12/11.
//

import Combine

protocol SummaryRepo {
    func fetchSummary() -> AnyPublisher<Summary, MoyangError>
    
    // For firebase
    func addSummaryListener() -> PassthroughSubject<Summary, MoyangError>
}
