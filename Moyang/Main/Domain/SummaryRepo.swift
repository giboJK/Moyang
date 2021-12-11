//
//  SummaryRepo.swift
//  Moyang
//
//  Created by 정김기보 on 2021/12/11.
//

import FirebaseFirestore
import FirebaseFirestoreSwift
import Combine

protocol SummaryRepo: ObservableObject {
    func fetchSummary() -> AnyPublisher<Summary, Error>
}
