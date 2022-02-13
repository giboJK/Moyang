//
//  LoginService.swift
//  Moyang
//
//  Created by kibo on 2022/01/11.
//

import Combine

protocol LoginService {
    func signup(id: String, pw: String, type: LoginType) -> AnyPublisher<Bool, MoyangError>
    func login(id: String, pw: String, type: LoginType) -> AnyPublisher<Bool, MoyangError>
    func pastorLogin(id: String, pw: String, type: LoginType) -> AnyPublisher<Bool, MoyangError>
    func fetchPastorList(type: LoginType) -> AnyPublisher<PastorList, MoyangError>
    func fetchUserData(id: String, type: LoginType) -> AnyPublisher<MemberDetail, MoyangError>
    func setUserData(memberDetail: MemberDetail) -> AnyPublisher<Bool, MoyangError>
}

enum LoginType: String {
    case email = "EMAIL"
    case google = "GOOGLE"
    case apple = "APPLE"
}
