//
//  SearchBar.swift
//  Moyang
//
//  Created by 정김기보 on 2022/02/20.
//

import SwiftUI

struct SearchBar: View {
    @Binding var text: String
    @Binding var isEditing: Bool
    
    var body: some View {
        ZStack {
            HStack {
                TextField("", text: $text)
                    .placeholder(when: text.isEmpty) {
                        Text("이름").foregroundColor(.sheep4)
                    }
                    .padding(8)
                    .padding(.horizontal, 28)
                    .background(Color.sheep1)
                    .foregroundColor(.nightSky1)
                    .font(.system(size: 16, weight: .regular, design: .default))
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.sheep4, lineWidth: 1)
                    )
                    .onTapGesture {
                        withAnimation {
                            isEditing = true
                        }
                    }
                if isEditing && text.count != 0 {
                    Button(action: {
                        withAnimation {
                            self.text = ""
                        }
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .frame(width: 20, height: 20)
                            .tint(.nightSky1)
                    }
                    .padding(.trailing, 4)
                    .transition(.slide)
                }
            }
            HStack {
                Image(systemName: "magnifyingglass")
                    .frame(width: 20, height: 20)
                    .tint(.nightSky1)
                    .padding(.leading, 8)
                Spacer()
            }
        }
    }
}

struct SearchBar_Previews: PreviewProvider {
    static var previews: some View {
        SearchBar(text: .constant(""), isEditing: .constant(false))
    }
}
