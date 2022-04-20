//
//  SortedPrayEditRow.swift
//  Moyang
//
//  Created by kibo on 2022/04/20.
//

import SwiftUI

struct SortedPrayEditRow: View {
    @State private var showingPray = true
    @FocusState var focus: Bool
    @Binding var title: String
    @Binding var pray: String
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                Text(title)
                    .font(.system(size: 16, weight: .regular))
                Spacer()
                Button(action: {
                    withAnimation {
                        showingPray.toggle()
                    }
                }, label: {
                    Image(systemName: showingPray ? "chevron.down" : "chevron.up")
                        .font(.system(size: 13, weight: .regular, design: .default))
                })
            }
            
            Divider()
                .frame(height: 0.5)
                .background(Color.sheep2)
                .padding(.bottom, 4)
            
            if showingPray {
                TextEditor(text: $pray)
                    .padding(EdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4))
                    .focused($focus)
                    .font(.system(size: 15, weight: .regular, design: .default))
                    .frame(minHeight: 64, alignment: .topLeading)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.sheep4, lineWidth: 0.5)
                    )
            }
        }
    }
}
