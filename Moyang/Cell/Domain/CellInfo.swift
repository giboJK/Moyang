//
//  CellInfo.swift
//  Moyang
//
//  Created by 정김기보 on 2021/10/25.
//

import Foundation
import SwiftUI

struct CellInfo: Codable, Identifiable {
    typealias Identifier = Int
    let id: Identifier
    let cellName: String
    let talkingSubject: String
    let questionList: [String]
    let dateString: String
    
    let memberList: [CellMemberInfo]
    
    enum CodingKeys: String, CodingKey {
        case id
        case cellName = "cell_name"
        case talkingSubject = "talking_subject"
        case questionList = "question_list"
        case dateString = "date_string"
        case memberList = "member_list"
    }
}

struct CellMemberInfo: Codable, Identifiable {
    typealias Identifier = Int
    let id: Identifier
    var memberName: String
    var praySubject: String
    var age: Int
    var sex: String
    var birth: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case memberName = "member_name"
        case praySubject = "pray_subject"
        case age
        case sex
        case birth
    }
}
