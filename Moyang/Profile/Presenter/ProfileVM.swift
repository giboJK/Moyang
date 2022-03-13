//
//  ProfileVM.swift
//  Moyang
//
//  Created by kibo on 2022/01/24.
//

import SwiftUI
import Combine

class ProfileVM: ObservableObject {
    private var cancellables = Set<AnyCancellable>()
    @Published var groupInfoItem: UserItem = UserItem()
    @Published var levelDesc: String = ""
    @Published var isAlarmOn: Bool = false
    @Published var alarmDate: Date = Date()
    
    init() {
        
    }
    
    func loadUserData() {
        if let myInfo = UserData.shared.myInfo {
            groupInfoItem = UserItem(userInfo: myInfo)
            
            if let userLevel = UserLevel(rawValue: myInfo.grade) {
                self.levelDesc = userLevel.levelDesc
            }
        }
        
        self.isAlarmOn = UserData.shared.isAlarmOn
        
        
        if let alarmTime = UserData.shared.alarmTiem?.toDate() {
            self.alarmDate = alarmTime
        }
    }
    
    func toggleAlarmOn() {
        isAlarmOn.toggle()
        
        if isAlarmOn {
            UserData.shared.alarmTiem = self.alarmDate.toString(format: "yyyy-MM-dd HH:mm:ss")
            Log.w("")
        }
        Log.w("")
    }
    
    func setAlarmTime() {
        UserData.shared.alarmTiem = self.alarmDate.toString(format: "yyyy-MM-dd HH:mm:ss")
        isAlarmOn = true
        Log.w("")
    }
}

extension ProfileVM {
    struct UserItem {
        var name: String = ""
        var email: String = ""
        
        init() { }
        
        init(userInfo: MemberDetail) {
            self.name = userInfo.memberName
            self.email = userInfo.email
        }
    }
}
