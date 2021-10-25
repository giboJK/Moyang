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
    static func fetchCellPreview()  -> AnyPublisher<CellPreview, Error>
    static func fetchCellInfo()  -> AnyPublisher<CellInfo, Error>
}

