//
//  LoginService.swift
//  Moyang
//
//  Created by kibo on 2022/01/11.
//

import Combine

protocol LoginService {
    func signup(id: String, pw: String, type: AuthType) -> AnyPublisher<Bool, MoyangError>
    func login(id: String, pw: String, type: AuthType) -> AnyPublisher<Bool, MoyangError>
    func pastorLogin(id: String, pw: String, type: AuthType) -> AnyPublisher<Bool, MoyangError>
    func fetchPastorList(type: AuthType) -> AnyPublisher<PastorList, MoyangError>
    func fetchUserData(id: String, type: AuthType) -> AnyPublisher<MemberDetail, MoyangError>
    func setUserData(memberDetail: MemberDetail) -> AnyPublisher<Bool, MoyangError>
}
