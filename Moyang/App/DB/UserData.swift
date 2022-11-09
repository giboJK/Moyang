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
    
    var isNotFirstLaunch: Bool {
        get {
            return UserDefaults.standard.bool(forKey: "IS_NOT_FIRST_LAUNCH")
        }
        set(v) {
            UserDefaults.standard.set(v, forKey: "IS_NOT_FIRST_LAUNCH")
        }
    }
    
    var fcmToken: String? {
        get {
            return UserDefaults.standard.string(forKey: "FCM_TOKEN")
        }
        set(v) {
            UserDefaults.standard.set(v, forKey: "FCM_TOKEN")
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
    
    var autoSavedPrayTitle: String? {
        get {
            return UserDefaults.standard.string(forKey: UserDefaultKey.autoSavedPrayTitle)
        }
        set(v) {
            UserDefaults.standard.set(v, forKey: UserDefaultKey.autoSavedPrayTitle)
        }
    }
    
    var autoSavedPrayContent: String? {
        get {
            return UserDefaults.standard.string(forKey: UserDefaultKey.autoSavedPrayContent)
        }
        set(v) {
            UserDefaults.standard.set(v, forKey: UserDefaultKey.autoSavedPrayContent)
        }
    }
    
    func clearAutoSave() {
        UserDefaults.standard.removeObject(forKey: UserDefaultKey.autoSavedPrayTitle)
        UserDefaults.standard.removeObject(forKey: UserDefaultKey.autoSavedPrayContent)
    }
    
    // MARK: - WorshipNote
    
    var autoSavedNoteTitle: String? {
        get {
            return UserDefaults.standard.string(forKey: UserDefaultKey.autoSavedNoteTitle)
        }
        set(v) {
            UserDefaults.standard.set(v, forKey: UserDefaultKey.autoSavedNoteTitle)
        }
    }
    
    var autoSavedNoteBible: String? {
        get {
            return UserDefaults.standard.string(forKey: UserDefaultKey.autoSavedNoteBible)
        }
        set(v) {
            UserDefaults.standard.set(v, forKey: UserDefaultKey.autoSavedNoteBible)
        }
    }
    
    var autoSavedNotePastor: String? {
        get {
            return UserDefaults.standard.string(forKey: UserDefaultKey.autoSavedNotePastor)
        }
        set(v) {
            UserDefaults.standard.set(v, forKey: UserDefaultKey.autoSavedNotePastor)
        }
    }
    
    var autoSavedNoteContent: String? {
        get {
            return UserDefaults.standard.string(forKey: UserDefaultKey.autoSavedNoteContent)
        }
        set(v) {
            UserDefaults.standard.set(v, forKey: UserDefaultKey.autoSavedNoteContent)
        }
    }
    
    var autoSavedNoteTags: [String]? {
        get {
            return UserDefaults.standard.object(forKey: UserDefaultKey.autoSavedNoteTag) as? [String]
        }
        set(v) {
            UserDefaults.standard.set(v, forKey: UserDefaultKey.autoSavedNoteTag)
        }
    }
}

class UserDefaultKey {
    static let autoSavedPrayTitle = "AUTO_SAVED_PRAY_TITLE"
    static let autoSavedPrayContent = "AUTO_SAVED_PRAY_CONTENT"
    
    // MARK: - WorshipNote
    static let autoSavedNoteTitle = "AUTO_SAVED_NOTE_TITLE"
    static let autoSavedNoteBible = "AUTO_SAVED_NOTE_BIBLE"
    static let autoSavedNotePastor = "AUTO_SAVED_NOTE_PASTOR"
    static let autoSavedNoteContent = "AUTO_SAVED_NOTE_CONTENT"
    static let autoSavedNoteTag = "AUTO_SAVED_NOTE_Tag"
}
