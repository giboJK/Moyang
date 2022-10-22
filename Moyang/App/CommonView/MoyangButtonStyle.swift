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
    
    @Environment(\.isEnabled) var isEnabled
    
    enum MoyangButtonType {
        case primary
        case black
        case secondary
        case ghost
        case warning
        case negative
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
                .background(isEnabled ? Color.nightSky2 : Color.sheep5)
                .foregroundColor(isEnabled ? .sheep1 : .sheep3)
                .cornerRadius(12)
                .opacity(configuration.isPressed ? 0.7 : 1.0)
        case .black:
            return configuration.label
                .font(primaryFont)
                .frame(width: width, height: height, alignment: .center)
                .background(isEnabled ? Color.nightSky1 : Color.sheep5)
                .foregroundColor(isEnabled ? .sheep1 : Color.sheep3)
                .cornerRadius(12)
                .opacity(configuration.isPressed ? 0.7 : 1.0)
        case .secondary:
            return configuration.label
                .font(secondaryFont)
                .frame(width: width, height: height, alignment: .center)
                .background(isEnabled ? Color.nightSky3 : Color.sheep5)
                .foregroundColor(isEnabled ? .sheep1 : .sheep3)
                .cornerRadius(12)
                .opacity(configuration.isPressed ? 0.7 : 1.0)
        case .ghost:
            return configuration.label
                .font(ghostFont)
                .frame(width: width, height: height, alignment: .center)
                .background(.clear)
                .foregroundColor(isEnabled ? .nightSky1 : .sheep3)
                .cornerRadius(12)
                .opacity(configuration.isPressed ? 0.7 : 1.0)
        case .warning:
            return configuration.label
                .font(warningFont)
                .frame(width: width, height: height, alignment: .center)
                .background(Color.appleRed1)
                .foregroundColor(isEnabled ? .sheep1 : .sheep3)
                .cornerRadius(12)
                .opacity(configuration.isPressed ? 0.7 : 1.0)
        case .negative:
            return configuration.label
                .font(ghostFont)
                .frame(width: width, height: height, alignment: .center)
                .background(.clear)
                .foregroundColor(.appleRed1)
                .cornerRadius(12)
                .opacity(configuration.isPressed ? 0.7 : 1.0)
        }
    }
}
