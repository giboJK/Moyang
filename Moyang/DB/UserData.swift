//
//  UserData.swift
//  Moyang
//
//  Created by 정김기보 on 2021/12/29.
//

import Foundation

class UserData {
    static let shared = UserData()
    
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
    
    var userID: String? {
        get {
            return UserDefaults.standard.string(forKey: "USER_ID")
        }
        set(v) {
            UserDefaults.standard.set(v, forKey: "USER_ID")
        }
    }
}
