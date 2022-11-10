//
//  PrayDetail.swift
//  Moyang
//
//  Created by kibo on 2022/11/08.
//

struct PrayDetail: Codable {
    let prayID: String
    let userID: String
    let userName: String
    let groupID: String?
    let groupName: String?
    var title: String
    var content: String
    var latestDate: String
    let createDate: String
    var answers: [PrayAnswer]
    var changes: [PrayChange]
    var replys: [PrayReply]
    
    // NewPrayVC -> PrayPrayingVC
    init(myPray: MyPray, groupID: String?, groupName: String?) {
        self.prayID = myPray.prayID
        self.userID = myPray.userID
        self.userName = UserData.shared.userInfo?.name ?? ""
        self.groupID = groupID
        self.groupName = groupName
        self.title = myPray.category
        self.content = myPray.content
        self.latestDate = myPray.latestDate
        self.createDate = myPray.createDate
        self.answers = []
        self.changes = []
        self.replys = []
    }
    
    enum CodingKeys: String, CodingKey {
        case prayID = "pray_id"
        case userID = "user_id"
        case userName = "user_name"
        case groupID = "group_id"
        case groupName = "group_name"
        case title = "title"
        case content = "content"
        case latestDate = "latest_date"
        case createDate = "create_date"
        case answers = "answers"
        case changes = "changes"
        case replys = "replys"
    }
}
