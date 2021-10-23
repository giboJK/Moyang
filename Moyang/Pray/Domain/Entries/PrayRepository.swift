//
//  PrayRepository.swift
//  Moyang
//
//  Created by 정김기보 on 2021/10/11.
//  Copyright © 2021 정김기보. All rights reserved.
//

import Foundation
import Combine

protocol PrayRepository {
    static func fetchPraySubject() -> AnyPublisher<PraySubject, Error>
}
