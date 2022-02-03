//
//  MoyangButtonStyle.swift
//  Moyang
//
//  Created by kibo on 2022/01/11.
//

import SwiftUI

struct MoyangButtonStyle: ButtonStyle {
    
    let primaryFont = Font(uiFont: .systemFont(ofSize: 16, weight: .bold))
    let secondaryFont = Font(uiFont: .systemFont(ofSize: 16, weight: .bold))
    let ghostFont = Font(uiFont: .systemFont(ofSize: 16, weight: .bold))
    let warningFont = Font(uiFont: .systemFont(ofSize: 16, weight: .bold))
    
    let width: CGFloat
    let height: CGFloat
    
    enum MoyangButtonType {
        case primary
        case secondary
        case ghost
        case warning
    }
    
    let type: MoyangButtonType
    
    public init(_ type: MoyangButtonType = .primary, width: CGFloat, height: CGFloat) {
        self.type = type
        self.width = width
        self.height = height
    }
    
    func makeBody(configuration: Self.Configuration) -> some View {
        switch type {
        case .primary:
            return configuration.label
                .font(primaryFont)
                .frame(width: width, height: height, alignment: .center)
                .background(Color.ydGreen1)
                .foregroundColor(.sheep1)
                .cornerRadius(16)
                .opacity(configuration.isPressed ? 0.7 : 1.0)
        case .secondary:
            return configuration.label
                .font(secondaryFont)
                .frame(width: width, height: height, alignment: .center)
                .background(Color.wilderness2)
                .foregroundColor(.sheep1)
                .cornerRadius(16)
                .opacity(configuration.isPressed ? 0.7 : 1.0)
        case .ghost:
            return configuration.label
                .font(ghostFont)
                .frame(width: width, height: height, alignment: .center)
                .background(.clear)
                .foregroundColor(.ydGreen1)
                .cornerRadius(16)
                .opacity(configuration.isPressed ? 0.7 : 1.0)
        case .warning:
            return configuration.label
                .font(warningFont)
                .frame(width: width, height: height, alignment: .center)
                .background(Color.appleRed1)
                .foregroundColor(.sheep1)
                .cornerRadius(16)
                .opacity(configuration.isPressed ? 0.7 : 1.0)
        }
    }
}
