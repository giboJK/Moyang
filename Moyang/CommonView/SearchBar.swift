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
                        Text("Search...").foregroundColor(.sheep4)
                    }
                    .padding(8)
                    .padding(.horizontal, 28)
                    .background(Color.sheep1)
                    .foregroundColor(.nightSky1)
                    .font(.system(size: 16, weight: .regular, design: .default))
                    .cornerRadius(8)
                    .onTapGesture {
                        withAnimation {
                            isEditing.toggle()
                        }
                    }
                if isEditing && text.count != 0 {
                    Button(action: {
                        withAnimation {
                            isEditing.toggle()
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
        .cornerRadius(8)
        .border(Color.nightSky3)
    }
}

struct SearchBar_Previews: PreviewProvider {
    @State static var text = ""
    @State static var isEditing = false
    
    static var previews: some View {
        SearchBar(text: $text, isEditing: $isEditing)
    }
}
