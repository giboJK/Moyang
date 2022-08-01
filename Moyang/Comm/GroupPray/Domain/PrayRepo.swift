//
//  GroupPrayRepo.swift
//  Moyang
//
//  Created by 정김기보 on 2022/06/28.
//

import Foundation

protocol PrayRepo {
    func addPray(content: String, tags: [String], isSecret: Bool, completion: ((Result<Int, MoyangError>) -> Void)?)
    func editPray(content: String, tags: [String], isSecret: Bool, completion: ((Result<Int, MoyangError>) -> Void)?)
}
