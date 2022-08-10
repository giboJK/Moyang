//
//  TodayTask.swift
//  Moyang
//
//  Created by kibo on 2022/08/10.
//

// MARK: - TodayTask
struct TodayTask: Codable {
    let id: String
    let type: Int
    let isDone: Bool
    
    enum CodingKeys: String, CodingKey {
        case id
        case type
        case isDone = "is_done"
    }
}

enum TodayTaskType: Int {
    case praying
    case readingBible
    case writingToday
    case quietTime
}
