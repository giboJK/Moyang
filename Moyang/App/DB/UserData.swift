//
//  UserData.swift
//  Moyang
//
//  Created by 정김기보 on 2021/12/29.
//

import Foundation

class UserData {
    static let shared = UserData()
    var userInfo: UserInfo?
    var groupID: String?
    var groupInfo: GroupInfo?
    
    func resetUserData() {
        userName = nil
        password = nil
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
    var email: String? {
        get {
            return UserDefaults.standard.string(forKey: "EMAIL")
        }
        set(v) {
            UserDefaults.standard.set(v, forKey: "EMAIL")
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
    
    var isAlarmOn: Bool {
        get {
            return UserDefaults.standard.bool(forKey: "IS_ALARM_ON")
        }
        set(v) {
            UserDefaults.standard.set(v, forKey: "IS_ALARM_ON")
        }
    }
    
    var todayPrayPopup: String? {
        get {
            return UserDefaults.standard.string(forKey: "TODAY_PRAY_POPUP")
        }
        set(v) {
            UserDefaults.standard.set(v, forKey: "TODAY_PRAY_POPUP")
        }
    }
    
    var alarmTiem: String? {
        get {
            return UserDefaults.standard.string(forKey: "ALARM_TIME")
        }
        set(v) {
            UserDefaults.standard.set(v, forKey: "ALARM_TIME")
        }
    }
    
    var autoSavedPray: String? {
        get {
            return UserDefaults.standard.string(forKey: UserDefaultKey.autoSavedPray)
        }
        set(v) {
            UserDefaults.standard.set(v, forKey: UserDefaultKey.autoSavedPray)
        }
    }
    
    var autoSavedTags: [String]? {
        get {
            return UserDefaults.standard.object(forKey: UserDefaultKey.autoSavedTags) as? [String]
        }
        set(v) {
            UserDefaults.standard.set(v, forKey: UserDefaultKey.autoSavedTags)
        }
    }
    
    func clearAutoSave() {
        UserDefaults.standard.removeObject(forKey: UserDefaultKey.autoSavedPray)
        UserDefaults.standard.removeObject(forKey: UserDefaultKey.autoSavedTags)
    }
    
}

class UserDefaultKey {
    static let autoSavedPray = "AUTO_SAVED_PRAY"
    static let autoSavedTags = "AUTO_SAVED_TAGS"
}
