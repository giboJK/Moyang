//
//  CellInfo.swift
//  Moyang
//
//  Created by 정김기보 on 2021/10/25.
//

import Foundation
import SwiftUI

struct CellInfo: Codable, Identifiable {
    typealias Identifier = String
    let id: Identifier
    let cellName: String
    let leader: CellMember
    let memberList: [CellMember]
    
    enum CodingKeys: String, CodingKey {
        case id
        case cellName = "cell_name"
        case leader = "leader"
        case memberList = "member_list"
    }
}

struct CellMemberDetail: Codable, Identifiable {
    typealias Identifier = String
    let id: Identifier
    var memberName: String
    var age: Int
    var sex: String
    var birth: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case memberName = "member_name"
        case age
        case sex
        case birth
    }
}
