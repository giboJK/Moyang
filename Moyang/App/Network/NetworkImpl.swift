//
//  NetworkImpl.swift
//  Moyang
//
//  Created by 정김기보 on 2022/05/25.
//

import Foundation
import UIKit
import Alamofire

class AFNetworkService: NetworkServiceProtocol {
    var urlSession: URLSession
    private var session: Session
    private var fileManager: FileManager
    private var scheme: String
    private var host: String
    
    init(sessionConfiguration: URLSessionConfiguration?,
         scheme: String = NetConst.scheme,
         host: String = NetConst.host) {
        if let configuration = sessionConfiguration {
            self.session = Session(configuration: configuration)
        } else {
            self.session = Session.default
        }
        self.urlSession = session.session
        self.fileManager = FileManager.default
        self.scheme = scheme
        self.host = host
    }
    
    
    func makeUrl(path: String) -> URL? {
        var components = URLComponents()
        components.scheme = scheme
        components.host = host
        components.path = path
        
        return components.url
    }
    
    func makeRequest(url: URL?,
                     method: NetworkService.HttpMethod,
                     parameters: [String: Any],
                     token: String?) -> RequestProtocol {
        return Request(url: url, method: method, parameters: parameters, token: token)
    }
    
    func makeRequest(url: URL?,
                     method: NetworkService.HttpMethod,
                     parameters: [String: Any]) -> RequestProtocol {
        return Request(url: url, method: method, parameters: parameters, token: nil)
    }
    
    func requestAPI<T: Codable>(request: RequestProtocol,
                                type: T.Type,
                                token: String?,
                                completion: @escaping (Result<T, Error>) -> Void) {
        if !Reachability.isConnectedToNetwork() {
            completion(.failure(MoyangError.reachability))
            Log.e("Network is unavailable.")
            return
        }
        var headers = CommonUtils.HEADER
        if let token = token {
            headers.add(name: NetConst.authTokenKey, value: token)
        }
        AF.request(request.url!,
                   method: HTTPMethod(rawValue: request.method.rawValue),
                   parameters: request.parameters,
                   headers: headers)
#if DEBUG
            .responseDecodable(of: T.self) { result in
                Log.i(result.request as Any)
                if let data = result.data {
                    Log.i(NSString(data: data, encoding: String.Encoding.utf8.rawValue) as Any)
                }
                if let requestData = result.request?.httpBody {
                    Log.i(NSString(data: requestData, encoding: String.Encoding.utf8.rawValue) as Any)
                }
            }
#endif
            .responseDecodable(of: T.self) { response in
                switch response.result {
                case .success(let value):
                    completion(.success(value))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    func requestData(request: RequestProtocol,
                     token: String?,
                     completion: @escaping (Result<Data, Error>) -> Void) {
        if !Reachability.isConnectedToNetwork() {
            completion(.failure(MoyangError.reachability))
            Log.e("Network is unavailable.")
            return
        }
        
        var headers = CommonUtils.HEADER
        if let token = token {
            headers.add(name: NetConst.authTokenKey, value: token)
        }
        AF.request(request.url!,
                   method: HTTPMethod(rawValue: request.method.rawValue),
                   parameters: request.parameters,
                   headers: headers)
#if DEBUG
            .responseData { result in
                Log.i(result.request as Any)
                if let data = result.data {
                    Log.i(NSString(data: data, encoding: String.Encoding.utf8.rawValue) as Any)
                }
                if let requestData = result.request?.httpBody {
                    Log.i(NSString(data: requestData, encoding: String.Encoding.utf8.rawValue) as Any)
                }
            }
#endif
            .responseData { response in
                switch response.result {
                case .success(let data):
                    completion(.success(data))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    func requestString(request: RequestProtocol,
                       token: String?,
                       completion: @escaping (Result<String, Error>) -> Void) {
        if !Reachability.isConnectedToNetwork() {
            completion(.failure(MoyangError.reachability))
            Log.e("Network is unavailable.")
            return
        }
        
        var headers = CommonUtils.HEADER
        if let token = token {
            headers.add(name: NetConst.authTokenKey, value: token)
        }
        AF.request(request.url!,
                   method: HTTPMethod(rawValue: request.method.rawValue),
                   parameters: request.parameters,
                   headers: headers)
#if DEBUG
            .responseString { result in
                Log.i(result.request as Any)
                if let data = result.data {
                    Log.i(NSString(data: data, encoding: String.Encoding.utf8.rawValue) as Any)
                }
                if let requestData = result.request?.httpBody {
                    Log.i(NSString(data: requestData, encoding: String.Encoding.utf8.rawValue) as Any)
                }
            }
#endif
            .responseString { response in
                switch response.result {
                case .success(let str):
                    completion(.success(str))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    func upload<T: Codable>(request: RequestProtocol,
                            type: T.Type,
                            token: String?,
                            completion: @escaping (Result<T, Error>) -> Void) {
        if !Reachability.isConnectedToNetwork() {
            completion(.failure(MoyangError.reachability))
            Log.e("Network is unavailable.")
            return
        }
        guard let urlString = request.url?.absoluteString else {
            completion(.failure(MoyangError.invalidURL))
            Log.e("invalid URL")
            return
        }
        
        var headers = CommonUtils.HEADER
        if let token = token {
            headers.add(name: NetConst.authTokenKey, value: token)
        }
        headers.add(name: "Content-Type", value: "multipart/form-data")
        
        let param = request.parameters
        let dataJPEG: UIImage? = param["file"] as? UIImage
        
        AF.upload(multipartFormData: { multipartFormData in
            
            for (key, value) in param where value is String {
                multipartFormData.append("\(value)".data(using: .utf8)!, withName: key)
            }
            
            if let img = dataJPEG?.jpegData(compressionQuality: 0.5) {
                multipartFormData.append(img, withName: "file", fileName: "file.jpeg", mimeType: "image/jpeg")
            }
            
        }, to: urlString, headers: headers)
#if DEBUG
        .responseDecodable(of: T.self) { result in
            Log.i(result.request as Any)
            if let data = result.data {
                Log.i(NSString(data: data, encoding: String.Encoding.utf8.rawValue) as Any)
            }
            if let requestData = result.request?.httpBody {
                Log.i(NSString(data: requestData, encoding: String.Encoding.utf8.rawValue) as Any)
            }
        }
#endif
        .responseDecodable(of: T.self) { response in
            switch response.result {
            case .success(let value):
                completion(.success(value))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func download(from sourceURL: URL, to fileURL: URL, parameters: [String: Any]?, completion: @escaping (URL?, Error?) -> Void) {
        let destination: DownloadRequest.Destination = { _, _ in
            let fileLocation = fileURL.absoluteString
            
            let documentsURL = self.fileManager.urls(for: .libraryDirectory, in: .userDomainMask)[0]
            let fileURL = documentsURL.appendingPathComponent(fileLocation)
            
            return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
        }
        
        let headers = CommonUtils.HEADER
        AF.download(sourceURL,
                    method: .get,
                    parameters: parameters,
                    headers: headers,
                    to: destination).response { response in
            completion(response.fileURL, response.error)
        }
    }
}
