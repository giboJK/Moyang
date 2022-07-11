//
//  BaseResponse.swift
//  Moyang
//
//  Created by kibo on 2022/07/11.
//

import Foundation

class BaseResponse: Codable {
    let code: Int
    let title: String?
    let errorCode: String?
    let errorMessage: String?
    let message: String?

    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        code = try container.decode(Int.self, forKey: .code)
        
        title = try? container.decode(String.self, forKey: .title)
        errorCode = try? container.decode(String.self, forKey: .errorCode)
        errorMessage = try? container.decode(String.self, forKey: .errorMessage)
        message = try? container.decode(String.self, forKey: .message)
    }
    
    enum CodingKeys: String, CodingKey {
        case code = "code"
        case title
        case errorCode = "error_code"
        case errorMessage = "error_msg"
        case message
    }
}
