//
//  NavigationLazyView.swift
//  Moyang
//
//  Created by 정김기보 on 2022/02/17.
//

import SwiftUI

struct NavigationLazyView<Content: View>: View {
    let build: () -> Content
    init(_ build: @autoclosure @escaping () -> Content) {
        self.build = build
    }
    var body: Content {
        build()
    }
}
