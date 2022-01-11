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
            .padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 15))
            .foregroundColor(Color.black)
            .background(Color.white)
            .cornerRadius(10)
            .shadow(color: .gray.opacity(0.4), radius: 4, x: 3.0, y: 3)
    }
}
