//
//  UserData.swift
//  Moyang
//
//  Created by 정김기보 on 2021/12/29.
//

import Foundation

class UserData {
    static let shared = UserData()
    var myInfo: MemberDetail?
    var groupInfo: GroupInfo?
    
    func resetUserData() {
        myInfo = nil
        groupInfo = nil
        userName = nil
        userID = nil
        password = nil
        isPastor = nil
    }
    
    var isNotFirstLaunch: Bool {
        get {
            return UserDefaults.standard.bool(forKey: "IS_NOT_FIRST_LAUNCH")
        }
        set(v) {
            UserDefaults.standard.set(v, forKey: "IS_NOT_FIRST_LAUNCH")
        }
    }
    
    var userName: String? {
        get {
            return UserDefaults.standard.string(forKey: "USER_NAME")
        }
        set(v) {
            UserDefaults.standard.set(v, forKey: "USER_NAME")
        }
    }
    
    /// Email address
    var userID: String? {
        get {
            return UserDefaults.standard.string(forKey: "USER_ID")
        }
        set(v) {
            UserDefaults.standard.set(v, forKey: "USER_ID")
        }
    }
    
    var password: String? {
        get {
            return UserDefaults.standard.string(forKey: "USER_PW")
        }
        set(v) {
            UserDefaults.standard.set(v, forKey: "USER_PW")
        }
    }
    
    var isPastor: Bool? {
        get {
            return UserDefaults.standard.bool(forKey: "IS_PASTOR")
        }
        set(v) {
            UserDefaults.standard.set(v, forKey: "IS_PASTOR")
        }
    }
}
