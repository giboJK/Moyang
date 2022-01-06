//
//  CellRepo.swift
//  Moyang
//
//  Created by 정김기보 on 2021/10/19.
//  Copyright © 2021 정김기보. All rights reserved.
//

import Foundation
import Combine

protocol CellRepo {
    func fetchCellPreview() -> AnyPublisher<CellPreview, Error>
    func fetchCellInfo() -> AnyPublisher<CellInfo, Error>
    
    func add(_ cellPrayInfo: CellPrayInfo) -> AnyPublisher<Bool, MoyangError>
    
    func addCellPrayListListener() -> PassthroughSubject<CellPrayInfo, MoyangError>
}
