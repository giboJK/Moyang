//
//  NewCellPrayVM.swift
//  Moyang
//
//  Created by 정김기보 on 2021/11/30.
//

import SwiftUI
import Combine

class NewCellPrayVM: ObservableObject, Identifiable {
    @Published var itemList = [NewCellPrayVM.NewPrayItem]()
    @Published var dateString = Date().toString()
    
    init() {
        loadCellMemberList()
    }
    
    func changeDate(date: Date) {
        dateString = date.toString()
    }
    
    private func loadCellMemberList() {
        Log.w(UserData.shared.groupInfo)
        guard let groupInfo = UserData.shared.groupInfo else { return }
        var list = [NewPrayItem]()
        groupInfo.memberList.forEach { member in
            list.append(NewPrayItem(name: member.name))
        }
        self.itemList = list
    }
    
    func addNewPray() {
        
    }
}

extension NewCellPrayVM {
    struct NewPrayItem: Hashable {
        var name: String
        var pray: String
        
        init(name: String) {
            self.name = name
            self.pray = "기도제목을 입력하세요"
        }
    }
}
