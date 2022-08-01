//
//  GroupPrayRepo.swift
//  Moyang
//
//  Created by 정김기보 on 2022/06/28.
//

import Foundation

protocol PrayRepo {
    func addPray(userID: String, groupID: String, content: String, tags: [String], isSecret: Bool,
                 completion: ((Result<BaseResponse, MoyangError>) -> Void)?)
    func editPray(userID: String, groupID: String, content: String, tags: [String], isSecret: Bool,
                  completion: ((Result<BaseResponse, MoyangError>) -> Void)?)
}
