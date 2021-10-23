//
//  PrayUseCaseProvider.swift
//  Moyang
//
//  Created by 정김기보 on 2021/09/14.
//  Copyright © 2021 정김기보. All rights reserved.
//

import Foundation

protocol PrayUseCaseProvider {
    func makeFetchPraySubjectUseCase() -> FetchPraySubject
}
