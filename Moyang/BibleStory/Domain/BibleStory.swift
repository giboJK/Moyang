//
//  BibleStory.swift
//  Moyang
//
//  Created by kibo on 2021/10/07.
//  Copyright © 2021 정김기보. All rights reserved.
//

import Foundation
import SwiftUI

struct BibleStory: Codable, Identifiable {
    typealias Identifier = Int
    var id: Identifier
    var title: String
    var description: String
    var content: String
    
    var imageName: String
    var image: Image {
        Image(imageName)
    }
}
