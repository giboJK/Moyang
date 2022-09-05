//
//  AppVersionInfo.swift
//  Moyang
//
//  Created by kibo on 2022/09/05.
//

import Foundation

struct AppVersionInfo: Codable {
    let version: String
    let status: String
    let updateDate: String
    
    enum CodingKeys: String, CodingKey {
        case version = "latest_version"
        case status = "version_status"
        case updateDate = "update_date"
    }
}
