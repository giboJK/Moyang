//
//  Encodable+.swift
//  Moyang
//
//  Created by 정김기보 on 2022/01/25.
//

import Foundation

extension Encodable {
    var dict: [String: Any]? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        guard let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
            return nil
        }
        return json
    }
}
