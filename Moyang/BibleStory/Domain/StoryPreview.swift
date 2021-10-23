//
//  StoryPreview.swift
//  Moyang
//
//  Created by 정김기보 on 2021/10/02.
//  Copyright © 2021 정김기보. All rights reserved.
//

import Foundation
import SwiftUI

struct StoryPreview: Codable, Identifiable {
    typealias Identifier = Int
    let id: Identifier
    var title: String
    var description: String
    
    var imageName: String
    var image: Image {
        Image(imageName)
    }
}
