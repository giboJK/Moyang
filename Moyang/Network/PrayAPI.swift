//
//  PrayAPI.swift
//  Moyang
//
//  Created by 정김기보 on 2021/12/07.
//

import Foundation
import Combine

enum PrayAPI {
    static func fetchPraySubject(id: String) -> AnyPublisher<PraySubject, MoyangError> {
        let url = URL(string: "https://api.unsplash.com/photos/random/?client_id=\(id)")!
        
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .reloadIgnoringLocalCacheData
        config.urlCache = nil
        let session = URLSession(configuration: config)
        
        var urlRequest = URLRequest(url: url)
        urlRequest.addValue("Accept-Version", forHTTPHeaderField: "v1")
        
        return session.dataTaskPublisher(for: urlRequest)
            .tryMap { response in
                guard let httpURLResponse = response.response as? HTTPURLResponse,
                      httpURLResponse.statusCode == 200 else {
                          throw MoyangError.statusCode
                      }
                return response.data
            }
            .decode(type: PraySubject.self, decoder: JSONDecoder())
            .mapError { MoyangError.map($0) }
            .eraseToAnyPublisher()
    }
}
