//
//  LoginService.swift
//  Moyang
//
//  Created by kibo on 2022/01/11.
//

import Combine

protocol LoginService {
    func signup(id: String, pw: String) -> AnyPublisher<Bool, MoyangError>
    func login(id: String, pw: String) -> AnyPublisher<Bool, MoyangError>
}
