//
//  BibleStoryRepo.swift
//  Moyang
//
//  Created by 정김기보 on 2021/10/02.
//  Copyright © 2021 정김기보. All rights reserved.
//

import Foundation
import Combine

protocol BibleStoryRepo {
    func fetchStoryPreview()  -> AnyPublisher<[StoryPreview], Error>
    static func fetchStoryPreviews() -> AnyPublisher<[StoryPreview], Error>
}
