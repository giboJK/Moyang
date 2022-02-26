//
//  GroupPreview.swift
//  Moyang
//
//  Created by 정김기보 on 2021/10/19.
//  Copyright © 2021 정김기보. All rights reserved.
//

import Foundation
import SwiftUI

struct GroupPreview: Codable {
    let name: String
    let talkingSubject: String
    let dateString: String
    
    let memberList: [Member]
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case talkingSubject = "talking_subject"
        case dateString = "date_string"
        case memberList = "member_list"
    }
}
