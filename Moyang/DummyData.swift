//
//  DummyData.swift
//  Moyang
//
//  Created by 정김기보 on 2021/10/24.
//

import Foundation
import Combine

final class DummyData: ObservableObject {
#if ENABLE_LOG
    @Published var cellPreview: CellPreview = load("CellPreviewData.json")
#endif
}

func load<T: Decodable>(_ filename: String) -> T {
    let data: Data

    guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
        else {
            fatalError("Couldn't find \(filename) in main bundle.")
    }

    do {
        data = try Data(contentsOf: file)
    } catch {
        fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
    }

    do {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    } catch {
        fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
    }
}
