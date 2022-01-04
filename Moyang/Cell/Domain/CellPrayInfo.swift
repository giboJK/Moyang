//
//  CellPrayInfo.swift
//  Moyang
//
//  Created by 정김기보 on 2021/11/23.
//

import Foundation
import SwiftUI

struct CellPrayInfo: Codable, Identifiable {
    typealias Identifier = String
    let id: Identifier
    let cellName: String
    let cellPrayList: [CellPrayList]
    
    enum CodingKeys: String, CodingKey {
        case id
        case cellName = "cell_name"
        case cellPrayList = "cell_pray_list"
    }
}

// MARK: - PrayList
struct CellPrayList: Codable {
    let dateString: String
    let memberPrayList: [CellMemberPray]
    
    enum CodingKeys: String, CodingKey {
        case dateString = "date_string"
        case memberPrayList = "member_pray_list"
    }
}

struct CellMemberPray: Codable {
    let memberName: String
    let pray: String

    enum CodingKeys: String, CodingKey {
        case memberName = "member_name"
        case pray = "pray"
    }
}
