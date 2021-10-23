//
//  View+.swift
//  Moyang
//
//  Created by 정김기보 on 2021/10/04.
//  Copyright © 2021 정김기보. All rights reserved.
//

import SwiftUI

extension View {
    func eraseToAnyView() -> AnyView {
        AnyView(self)
    }
}
