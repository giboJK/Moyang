//
//  GroupRepo.swift
//  Moyang
//
//  Created by 정김기보 on 2021/10/19.
//  Copyright © 2021 정김기보. All rights reserved.
//

import Foundation
import Combine

protocol GroupRepo {
    func fetchCellPreview() -> AnyPublisher<GroupPreview, Error>
    func fetchGroupInfo() -> AnyPublisher<GroupInfo, Error>
    
    func add(_ cellPrayInfo: CellPrayInfo) -> AnyPublisher<Bool, MoyangError>
    
    func addCellPrayListListener() -> PassthroughSubject<CellPrayInfo, MoyangError>
}
