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
        let cellMemberPray = [CellMemberPray(id: 123458, memberName: "정김기보",
                                             praySubject: "공동체 안에서 더욱 굳건해지게 하소서"),
                              CellMemberPray(id: 294942, memberName: "김기보 정",
                                             praySubject: "청년이 무엇으로 정결케 하리오 오직 주의 말씀과 기도뿐이라"),
                              CellMemberPray(id: 212304, memberName: "기보 킴 정",
                                             praySubject: "주를 경외함이 모든 지식의 근본이오니"),
                              CellMemberPray(id: 612304, memberName: "기보 킴 정-2",
                                             praySubject: "주를 기다립니다."),
                              CellMemberPray(id: 912304, memberName: "기보 킴 정-3",
                                             praySubject: "한 마음에 두 마음을 품지 않게 하시고 매일 제 안에 새 영을 창조하소서"),
        ]
        let cellPreview = CellPreview(id: 2444,
                                      cellName: "정김기보셀",
                                      talkingSubject: "네 부모를 공경하라",
                                      dateString: "2021-10-23",
                                      prayList: cellMemberPray)
        return Just(cellPreview)
            .setFailureType(to: Error.self)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
//        return Empty(completeImmediately: false).eraseToAnyPublisher()
    }
}
