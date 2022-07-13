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
    var sermon: Sermon?
    
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
    
    var isAlarmOn: Bool {
        get {
            return UserDefaults.standard.bool(forKey: "IS_ALARM_ON")
        }
        set(v) {
            UserDefaults.standard.set(v, forKey: "IS_ALARM_ON")
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
