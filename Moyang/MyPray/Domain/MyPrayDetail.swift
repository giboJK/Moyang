//
//  MyPrayDetail.swift
//  Moyang
//
//  Created by kibo on 2022/11/08.
//

struct MyPrayDetail: Codable {
    let prayID: String
    let userID: String
    var title: String
    var content: String
    var latestDate: String
    let createDate: String
    var answers: [PrayAnswer]
    var changes: [PrayChange]
    
    init(myPray: MyPray) {
        self.prayID = myPray.prayID
        self.userID = myPray.userID
        self.title = myPray.title
        self.content = myPray.content
        self.latestDate = myPray.latestDate
        self.createDate = myPray.createDate
        self.answers = []
        self.changes = []
    }
    
    enum CodingKeys: String, CodingKey {
        case prayID = "pray_id"
        case userID = "user_id"
        case title = "title"
        case content = "content"
        case latestDate = "latest_date"
        case createDate = "create_date"
        case answers = "answers"
        case changes = "changes"
    }
}
