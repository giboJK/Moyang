//
//  CellPreview.swift
//  Moyang
//
//  Created by 정김기보 on 2021/10/19.
//  Copyright © 2021 정김기보. All rights reserved.
//

import Foundation
import SwiftUI

struct CellPreview: Codable, Identifiable {
    typealias Identifier = Int
    let id: Identifier
    let cellName: String
    let talkingSubject: String
    let dateString: String
    
    let prayList: [CellMemberPray]
    
    enum CodingKeys: String, CodingKey {
        case id
        case cellName = "cell_name"
        case talkingSubject = "talking_subject"
        case dateString = "date_string"
        case prayList = "pray_list"
    }
}

struct CellMemberPray: Codable, Identifiable {
    typealias Identifier = Int
    let id: Identifier
    var memberName: String
    var praySubject: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case memberName = "member_name"
        case praySubject = "pray_subject"
    }
}
