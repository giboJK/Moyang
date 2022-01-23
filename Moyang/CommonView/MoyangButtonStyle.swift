//
//  MoyangButtonStyle.swift
//  Moyang
//
//  Created by kibo on 2022/01/11.
//

import SwiftUI

struct MoyangButtonStyle: ButtonStyle {
    
    let primaryFont = Font(uiFont: .systemFont(ofSize: 20, weight: .semibold))
    let secondaryFont = Font(uiFont: .systemFont(ofSize: 20, weight: .semibold))
    let ghostFont = Font(uiFont: .systemFont(ofSize: 20, weight: .regular))
    let warningFont = Font(uiFont: .systemFont(ofSize: 20, weight: .semibold))
    
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
                .background(Color.desertStone1)
                .foregroundColor(.sheep1)
                .cornerRadius(16)
                .opacity(configuration.isPressed ? 0.7 : 1.0)
        case .secondary:
            return configuration.label
                .font(secondaryFont)
                .frame(width: width, height: height, alignment: .center)
                .background(Color.desertStone2)
                .foregroundColor(.sheep1)
                .cornerRadius(16)
                .opacity(configuration.isPressed ? 0.7 : 1.0)
        case .ghost:
            return configuration.label
                .font(ghostFont)
                .frame(width: width, height: height, alignment: .center)
                .background(.clear)
                .foregroundColor(.sky1)
                .cornerRadius(16)
                .opacity(configuration.isPressed ? 0.7 : 1.0)
        case .warning:
            return configuration.label
                .font(warningFont)
                .frame(width: width, height: height, alignment: .center)
                .background(.red)
                .foregroundColor(.sheep1)
                .cornerRadius(16)
                .opacity(configuration.isPressed ? 0.7 : 1.0)
        }
    }
}
