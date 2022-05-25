//
//  Request.swift
//  Moyang
//
//  Created by 정김기보 on 2022/05/25.
//

import Foundation

protocol RequestProtocol {
    var url: URL? { get }
    var method: NetworkService.HttpMethod { get }
    var parameters: [String: Any] { get }
    var token: String? { get }
}

class Request: RequestProtocol {
    var url: URL?
    var method: NetworkService.HttpMethod
    var parameters: [String: Any]
    var token: String?
    
    init(url: URL?,
         method: NetworkService.HttpMethod,
         parameters: [String: Any],
         token: String? = nil) {
        self.url = url
        self.method = method
        self.parameters = parameters
        self.token = token
    }
}
