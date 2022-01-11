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
                .background(Color.dessertStone)
                .foregroundColor(.white)
                .cornerRadius(16)
        case .secondary:
            return configuration.label
                .font(secondaryFont)
                .frame(width: width, height: height, alignment: .center)
                .background(Color.desertLightStone)
                .foregroundColor(.white)
                .cornerRadius(16)
        case .ghost:
            return configuration.label
                .font(ghostFont)
                .frame(width: width, height: height, alignment: .center)
                .background(.clear)
                .foregroundColor(.black)
                .cornerRadius(16)
        case .warning:
            return configuration.label
                .font(warningFont)
                .frame(width: width, height: height, alignment: .center)
                .background(.red)
                .foregroundColor(.white)
                .cornerRadius(16)
        }
    }
}
