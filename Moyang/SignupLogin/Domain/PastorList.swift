//
//  PastorList.swift
//  Moyang
//
//  Created by kibo on 2022/01/18.
//

import Foundation

struct PastorList: Codable {
    let pastors: [String]
    
    enum CodingKeys: String, CodingKey {
        case pastors
    }
}
