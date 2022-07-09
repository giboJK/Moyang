//
//  AllGroupRepo.swift
//  Moyang
//
//  Created by 정김기보 on 2022/07/09.
//

import Foundation

protocol AllGroupRepo {
    func fetchGroupList(myInfo: MemberDetail, completion: ((Result<[GroupInfo], MoyangError>) -> Void)?)
}
