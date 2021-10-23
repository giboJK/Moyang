//
//  BibleStoryRepoImpl.swift
//  Moyang
//
//  Created by 정김기보 on 2021/10/03.
//  Copyright © 2021 정김기보. All rights reserved.
//

import Foundation
import Combine

class BibleStoryRepoImpl: BibleStoryRepo {
    static func fetchStoryPreviews() -> AnyPublisher<[StoryPreview], Error> {
        let dummyOne = StoryPreview(id: 11,
                                    title: "다윗",
                                    description: "골리앗을 죽이다",
                                    imageName: "david")
        let dummyTwo = StoryPreview(id: 12,
                                    title: "모세",
                                    description: "골리앗을 죽이다",
                                    imageName: "moses")
        return Just([dummyOne, dummyTwo])
            .setFailureType(to: Error.self)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func fetchStoryPreview() -> AnyPublisher<[StoryPreview], Error> {
        let dummyOne = StoryPreview(id: 11,
                                    title: "다윗",
                                    description: "골리앗을 죽이다",
                                    imageName: "david")
        let dummyTwo = StoryPreview(id: 12,
                                    title: "모세",
                                    description: "홍해를 가르다",
                                    imageName: "moses")
//        return Empty(completeImmediately: false).eraseToAnyPublisher()
        return Just([dummyOne, dummyTwo])
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}
