//
//  ProfileVM.swift
//  Moyang
//
//  Created by kibo on 2022/01/24.
//

import SwiftUI
import Combine
import GoogleSignIn
import Firebase

class ProfileVM: ObservableObject {
    private var cancellables = Set<AnyCancellable>()
    @Published var groupInfoItem: UserItem = UserItem()
    @Published var name: String = "이름"
    @Published var email: String = "이메일"
    
    @Published var levelDesc: String = "새싹 그리스도인"
    @Published var isAlarmOn: Bool = false
    @Published var alarmDate: Date = Date()
    
    @Published var logoutResult: Result<Bool, Error>?
    
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
    
    func logout() {
        if UserData.shared.authType == AuthType.google.rawValue {
            googleSignOut()
        } else {
            emailSignOut()
        }
    }
    
    private func emailSignOut() {
        do {
            UserData.shared.resetUserData()
            try Auth.auth().signOut()
            logoutResult = .success(true)
        } catch {
            Log.e(error)
            logoutResult = .failure(error)
        }
    }
    
    private func googleSignOut() {
        GIDSignIn.sharedInstance.signOut()
        
        do {
            UserData.shared.resetUserData()
            try Auth.auth().signOut()
            logoutResult = .success(true)
        } catch {
            Log.e(error)
            logoutResult = .failure(error)
        }
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
