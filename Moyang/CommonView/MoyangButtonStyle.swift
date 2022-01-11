//
//  MoyangButtonStyle.swift
//  Moyang
//
//  Created by kibo on 2022/01/11.
//

import SwiftUI

  struct MoyangButtonStyle: ButtonStyle {

      let buttonFont = Font(uiFont: .systemFont(ofSize: 20, weight: .semibold))

      let width: CGFloat
      let height: CGFloat

      public init(width: CGFloat, height: CGFloat) {
          self.width = width
          self.height = height
      }
      
      func makeBody(configuration: Self.Configuration) -> some View {
          configuration.label
              .font(buttonFont)
              .frame(width: width, height: height, alignment: .center)
              .background(Color.dessertStone)
              .foregroundColor(.white)
              .cornerRadius(16)
              .scaleEffect(configuration.isPressed ? 1.2 : 1)
              .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
      }
  }
