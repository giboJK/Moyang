//
//  GroupPrayRepo.swift
//  Moyang
//
//  Created by 정김기보 on 2022/06/28.
//

import Foundation

protocol GroupPrayRepo {
    func editPray(myInfo: MemberDetail, prayID: String, pray: String, tags: [String], isSecret: Bool, isRequestPray: Bool,
                  completion: ((Result<Bool, MoyangError>) -> Void)?)
}
