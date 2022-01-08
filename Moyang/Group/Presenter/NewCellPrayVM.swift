//
//  NewCellPrayVM.swift
//  Moyang
//
//  Created by 정김기보 on 2021/11/30.
//

import SwiftUI
import Combine

class NewCellPrayVM: ObservableObject, Identifiable {
    @Published var memberNewPrayList = [MemberNewPray]()
    @Published var dateString = Date().toString()
    
    @Published var text: String = ""
    init() {
        loadCellMemberList()
    }
    
    func changeDate(date: Date) {
        dateString = date.toString()
    }
    
    private func loadCellMemberList() {
        let cellInfo = DummyData().groupInfo
        
        var memberNewPrayList = [MemberNewPray]()
        cellInfo.memberList.forEach {
            memberNewPrayList.append(MemberNewPray(name: $0.name))
        }
        self.memberNewPrayList = memberNewPrayList
    }
}

extension NewCellPrayVM {
    struct MemberNewPray: Hashable {
        var name: String
        var pray: String
        
        init(name: String) {
            self.name = name
            self.pray = "기도제목을 입력하세요"
        }
    }
}
