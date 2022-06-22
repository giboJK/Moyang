//
//  AppInfo.swift
//  Moyang
//
//  Created by 정김기보 on 2022/06/22.
//

import Foundation

// MARK: - FittoResponse
class AppInfo: Codable {
    let isUpdateRequired: Bool
    let updateMessage: String?
    let version: String?

    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        isUpdateRequired = try container.decode(Bool.self, forKey: .isUpdateRequired)
        updateMessage = try? container.decode(String.self, forKey: .updateMessage)
        version = try? container.decode(String.self, forKey: .version)
    }
    
    enum CodingKeys: String, CodingKey {
        case isUpdateRequired = "is_update_required"
        case updateMessage = "update_message"
        case version = "version_ios"
    }
}
