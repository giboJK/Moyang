//
//  PrayRepoImpl.swift
//  Moyang
//
//  Created by 정김기보 on 2021/10/11.
//  Copyright © 2021 정김기보. All rights reserved.
//

import Foundation
import Combine

class PrayRepoImpl: PrayRepo {
    static func fetchPraySubject() -> AnyPublisher<PraySubject, Error> {
        let dummy = PraySubject(id: 11,
                                subject: "저의 시선을 땅이 아니라 하늘에 두게 하소서.",
                                timeString: "2021-10-11 08:30")
        return Just(dummy)
            .setFailureType(to: Error.self)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
