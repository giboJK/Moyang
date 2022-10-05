//
//  NoticeRepo.swift
//  Moyang
//
//  Created by kibo on 2022/10/05.
//

import Foundation

protocol NoticeRepo {
    func fetchNotices(completion: ((Result<FetchNoticesResponse, Error>) -> Void)?)
}

class FetchNoticesResponse: BaseResponse {
    let list: [Notice]
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        list = try container.decode([Notice].self, forKey: .list)
        try super.init(from: decoder)
    }
    
    enum CodingKeys: String, CodingKey {
        case list = "data"
    }
}
