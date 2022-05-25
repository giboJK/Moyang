//
//  Network.swift
//  Moyang
//
//  Created by 정김기보 on 2022/05/25.
//

import Foundation
import UIKit
import Alamofire

protocol NetworkServiceProtocol {
    var urlSession: URLSession { get }
    
    func makeUrl(path: String) -> URL?
    
    func makeRequest(url: URL?,
                     method: NetworkService.HttpMethod,
                     parameters: [String: Any],
                     token: String?) -> RequestProtocol
    
    func makeRequest(url: URL?,
                     method: NetworkService.HttpMethod,
                     parameters: [String: Any]) -> RequestProtocol
    
    func requestAPI<T: Codable>(request: RequestProtocol,
                                type: T.Type,
                                token: String?,
                                completion: @escaping (Result<T, Error>) -> Void)
    
    func requestData(request: RequestProtocol,
                     token: String?,
                     completion: @escaping (Result<Data, Error>) -> Void)
    
    func requestString(request: RequestProtocol,
                       token: String?,
                       completion: @escaping (Result<String, Error>) -> Void)
    
    func upload<T: Codable>(request: RequestProtocol,
                            type: T.Type,
                            token: String?,
                            completion: @escaping (Result<T, Error>) -> Void)
    
    func download(from sourceURL: URL,
                  to fileURL: URL,
                  parameters: [String: Any]?,
                  completion: @escaping (URL?, Error?) -> Void)
}

extension NetworkServiceProtocol {
    
}

class NetworkService {
    enum HttpMethod: String, RawRepresentable, Equatable, Hashable {
        case get
        case post
        case put = "PUT"
        case delete
        case patch = "PATCH"
    }
}
