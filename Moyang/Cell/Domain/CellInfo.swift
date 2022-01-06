//
//  CellInfo.swift
//  Moyang
//
//  Created by 정김기보 on 2021/10/25.
//

import Foundation

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
