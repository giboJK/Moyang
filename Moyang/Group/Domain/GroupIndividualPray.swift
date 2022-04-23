//
//  GroupIndividualPray.swift
//  Moyang
//
//  Created by kibo on 2022/04/23.
//

// MARK: - GroupIndividualPray
struct GroupIndividualPray: Codable {
    let groupID: String
    let date: String
    let pray: String

    enum CodingKeys: String, CodingKey {
        case groupID = "group_id"
        case date
        case pray
    }
}
