//
//  MainCard.swift
//  Moyang
//
//  Created by 정김기보 on 2021/11/15.
//

import SwiftUI

//struct AppButtonStyle: ButtonStyle {
//
//    let buttonFont = Font.custom("Zilla Slab", size: 20).weight(.bold)
//
//    func makeBody(configuration: Self.Configuration) -> some View {
//        configuration
//            .label
//            .font(buttonFont)
//            .multilineTextAlignment(.center)
//            .lineLimit(1)
//            .padding(.horizontal, 10)
//            .foregroundColor(.white)
//            .offset(y: -1)
//            .frame(height: 30)
//            .background(Color.black)
//            .clipShape(RoundedRectangle(cornerRadius: 10))
//            .scaleEffect(configuration.isPressed ? 0.9 : 1)
//            .opacity(configuration.isPressed ? 0.6 : 1)
//            .animation(.spring())
//    }
//}

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
