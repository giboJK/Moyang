//
//  MoyangError.swift
//  Moyang
//
//  Created by 정김기보 on 2021/12/07.
//

import Foundation

enum MoyangError: Error {
    case statusCode
    case decodingFailed
    case invalidURL
    case emptyData
    case other(Error)
    
    static func map(_ error: Error) -> MoyangError {
        return (error as? MoyangError) ?? .other(error)
    }
}
