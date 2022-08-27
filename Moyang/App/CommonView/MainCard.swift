//
//  MainCard.swift
//  Moyang
//
//  Created by 정김기보 on 2021/11/15.
//

import SwiftUI

struct MainCard: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundColor(Color.nightSky1)
            .background(Color.sheep1)
            .cornerRadius(12)
            .shadow(color: .gray.opacity(0.4), radius: 4, x: 3.0, y: 3)
    }
}
