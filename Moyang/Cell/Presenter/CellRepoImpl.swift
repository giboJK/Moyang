//
//  CellRepoImpl.swift
//  Moyang
//
//  Created by 정김기보 on 2021/10/19.
//  Copyright © 2021 정김기보. All rights reserved.
//

import Foundation
import Combine

class CellRepoImpl: CellRepo {
    
    static func fetchCellPreview() -> AnyPublisher<CellPreview, Error> {
        return Just(DummyData().cellPreview)
            .setFailureType(to: Error.self)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
//        return Empty(completeImmediately: false).eraseToAnyPublisher()
    }
    
    static func fetchCellInfo() -> AnyPublisher<CellInfo, Error> {
        return Just(DummyData().cellInfo)
            .setFailureType(to: Error.self)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
