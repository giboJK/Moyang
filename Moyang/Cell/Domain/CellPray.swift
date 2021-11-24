//
//  CellPray.swift
//  Moyang
//
//  Created by 정김기보 on 2021/11/23.
//

import Foundation
import SwiftUI

struct CellPray: Codable, Identifiable {
    typealias Identifier = Int
    let id: Identifier
    let cellName: String
    let memberList: [String]
    let prayList: [String]
    
    enum CodingKeys: String, CodingKey {
        case id
        case cellName = "cell_name"
        case memberList = "member_list"
        case prayList = "pray_list"
    }
}
