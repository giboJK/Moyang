//
//  TopTabBar.swift
//  Moyang
//
//  Created by kibo on 2022/03/05.
//

import SwiftUI

struct TopTabBar: View {
    @Binding var tabIndex: Int
    
    var body: some View {
        HStack(spacing: 20) {
            TabBarButton(text: "나눔", isSelected: .constant(tabIndex == 0))
                .onTapGesture { onButtonTapped(index: 0) }
                .frame(maxWidth: .infinity)
            TabBarButton(text: "기도", isSelected: .constant(tabIndex == 1))
                .onTapGesture { onButtonTapped(index: 1) }
                .frame(maxWidth: .infinity)
            Spacer()
        }
        .border(width: 1, edges: [.bottom], color: .nightSky1)
    }
    
    private func onButtonTapped(index: Int) {
        withAnimation { tabIndex = index }
    }
}

struct TabBarButton: View {
    let text: String
    @Binding var isSelected: Bool
    var body: some View {
        Text(text)
            .foregroundColor(.nightSky1)
            .fontWeight(isSelected ? .heavy : .regular)
            .font(.system(size: 16, weight: .regular, design: .default))
            .padding(.bottom,10)
            .border(width: isSelected ? 2 : 1, edges: [.bottom], color: .black)
    }
}

struct EdgeBorder: Shape {
    var width: CGFloat
    var edges: [Edge]
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        for edge in edges {
            var x: CGFloat {
                switch edge {
                case .top, .bottom, .leading: return rect.minX
                case .trailing: return rect.maxX - width
                }
            }
            
            var y: CGFloat {
                switch edge {
                case .top, .leading, .trailing: return rect.minY
                case .bottom: return rect.maxY - width
                }
            }
            
            var w: CGFloat {
                switch edge {
                case .top, .bottom: return rect.width
                case .leading, .trailing: return self.width
                }
            }
            
            var h: CGFloat {
                switch edge {
                case .top, .bottom: return self.width
                case .leading, .trailing: return rect.height
                }
            }
            path.addPath(Path(CGRect(x: x, y: y, width: w, height: h)))
        }
        return path
    }
}

extension View {
    func border(width: CGFloat, edges: [Edge], color: SwiftUI.Color) -> some View {
        overlay(EdgeBorder(width: width, edges: edges).foregroundColor(color))
    }
}
