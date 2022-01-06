//
//  CellMeetingVM.swift
//  Moyang
//
//  Created by 정김기보 on 2021/10/21.
//  Copyright © 2021 정김기보. All rights reserved.
//

import SwiftUI
import Combine

class CellMeetingVM: ObservableObject {
    @Published var answerList: [String] = Array(repeating: "", count: 10)
    @Published var cellInfo: CellInfoItem
    
    private var disposables = Set<AnyCancellable>()
    
    private var cellRepo: CellRepo
    
    init(cellRepo: CellRepo) {
        self.cellRepo = cellRepo
        cellInfo = CellInfoItem(cellInfo: CellInfo(id: "",
                                                   cellName: "",
                                                   leader: CellMember(id: "", name: "", profileURL: ""),
                                                   memberList: []))
    }
    
    deinit {
        Log.i(self)
        disposables.removeAll()
    }
}

extension CellMeetingVM {
    typealias Identifier = Int
    struct CellInfoItem {
        var cellName: String
        let talkingSubject: String
        var questionList: [String]
        let dateString: String
        
        init(cellInfo: CellInfo) {
            cellName = cellInfo.cellName
            talkingSubject = "셀모임 주제~"
            questionList = ["아하하하 1", "우라라라라 2", "그우어ㅓ어3", "잇츠 퀘스쳔4"]
            dateString = "2022-01-02"
        }
    }
}
