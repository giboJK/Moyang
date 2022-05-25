//
//  CommonUtils.swift
//  Moyang
//
//  Created by 정김기보 on 2022/05/25.
//

import Foundation
import UIKit
import CryptoKit
import Alamofire

class CommonUtils {
    static var HEADER: HTTPHeaders {
        let model = CommonUtils.deviceModel()
        let osver = CommonUtils.osVersion()
        let deviceLocale = CommonUtils.deviceLocale()
        
        return [
            "X-Moyang-App-Info": "app_version=\(CommonUtils.currentVersion);device_model=\(model);os_version=\(osver);os_type=iOS;client_lang=\(deviceLocale)",
            "X-Moyang-Request-Time": Date().toString("yyyy-MM-dd'T'HH:mm:ss (Z)"),
            "X-Moyang-Auth-Token": ""]
    }
    
    static func osVersion() -> String {
        return UIDevice.current.systemVersion
    }
    
    static func deviceModel() -> String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        return identifier
    }
    
    /// 디바이스 로케일 확인
    static func deviceLocale() -> String {
        let localeID = Locale.preferredLanguages.first
        let deviceLocale = (Locale(identifier: localeID ?? "").languageCode) ?? ""
        
        return deviceLocale
    }
    
    /// 어플리케이션 고유 키
    static var appUniqueKey: String {
        return UIDevice.current.identifierForVendor!.uuidString
    }
    
    /// 앱 버젼
    static var currentVersion: String {
        if let ver = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            return ver
        }
        return "0"
    }
    
    /// 앱 빌드 버전
    static var currentBuildVersion: String {
        if let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String {
            return build
        }
        return "0"
    }
    
    /// 업데이트 체크
    static func needUpdate(newVer: String?) -> Bool {
        if (newVer == nil)||(newVer == "") {
            return false
        } else {
            let isUpdate = (self.currentVersion.compare(newVer!, options: .numeric) == .orderedAscending)
            return isUpdate
        }
    }
    
    static func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            return String(format: "%02x", $0)
        }.joined()
        
        return hashString
    }
}
