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
    let title: String?
    let content: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case type
        case isDone = "is_done"
        case title
        case content
    }
}

enum TodayTaskType: Int {
    case worship
    case praise
    case pray
    case study
    case quietTime
    case stop
    case love
    
    var defaultTitle: String {
        switch self {
        case .worship:
            return "예배드리기"
        case .praise:
            return "찬양하기"
        case .pray:
            return "기도하기"
        case .study:
            return "하나님 공부하기"
        case .quietTime:
            return "말씀 묵상하기"
        case .stop:
            return "잠깐 멈추기"
        case .love:
            return "사랑하기"
        }
    }
    
    var defaultTime: Int {
        switch self {
        case .worship:
            return 30
        case .praise:
            return 15
        case .pray:
            return 5
        case .study:
            return 30
        case .quietTime:
            return 30
        case .stop:
            return 30
        case .love:
            return 0
        }
    }
}
