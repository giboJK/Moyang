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
    private var loginService: LoginService
    @Published var infoItem: UserItem = UserItem()
    @Published var name: String = "이름"
    @Published var email: String = "이메일"
    
    @Published var levelDesc: String = "새싹 그리스도인"
    @Published var isAlarmOn: Bool = false
    @Published var alarmDate: Date = Date()
    
    @Published var logoutResult: Result<Bool, Error>?
    
    init(loginService: LoginService) {
        self.loginService = loginService
    }
    
    func loadUserData() {
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
        UserData.shared.clearAutoSave()
        loginService.logout { [weak self] result in
            switch result {
            case .success(let isSuccess):
                self?.logoutResult = .success(isSuccess)
                NotificationCenter.default.post(name: NSNotification.Name("LOGOUT_SUCCESS"), object: nil, userInfo: nil)
            case .failure(let error):
                Log.e(error)
                self?.logoutResult = .failure(error)
            }
        }
    }
}

extension ProfileVM {
    struct UserItem {
        var name: String = ""
        var email: String = ""
        
        init() { }
        
        init(userInfo: UserInfo) {
            self.name = userInfo.name
            self.email = userInfo.email
        }
    }
}
