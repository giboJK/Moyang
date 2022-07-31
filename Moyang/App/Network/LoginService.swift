//
//  LoginService.swift
//  Moyang
//
//  Created by kibo on 2022/01/11.
//

import Combine

protocol LoginService {
    func signup(id: String, pw: String, type: AuthType) -> AnyPublisher<Bool, MoyangError>
    func emailLogin(id: String, pw: String) -> AnyPublisher<Bool, MoyangError>
    func googleLogin() -> AnyPublisher<String, MoyangError>
    func pastorLogin(id: String, pw: String, type: AuthType) -> AnyPublisher<Bool, MoyangError>
    func logout(completion: @escaping (Result<Bool, Error>) -> Void)
}

enum AuthType: String {
    case google = "GOOGLE"
    case apple = "APPLE"
}
