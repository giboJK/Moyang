//
//  MemberSearchRow.swift
//  Moyang
//
//  Created by 정김기보 on 2022/02/21.
//

import SwiftUI

struct MemberSearchRow: View {
    var name: String
    var email: String
    var birth: String
    var isSelected: Bool
    
    var body: some View {
        HStack(spacing: 0) {
            if isSelected {
                Image(systemName: "checkmark")
                    .tint(.sheep2)
            }
            VStack(spacing: 0) {
                HStack(spacing: 0) {
                    Text(name)
                        .foregroundColor(isSelected ? .sheep1 : .nightSky1)
                        .font(.system(size: 16, weight: .regular, design: .default))
                        .padding(.leading, 24)
                    Spacer()
                    Text(birth)
                        .foregroundColor(isSelected ? .sheep1 : .nightSky1)
                        .font(.system(size: 16, weight: .regular, design: .default))
                        .padding(.trailing, 24)
                }
                HStack(spacing: 0) {
                    Text(email)
                        .foregroundColor(isSelected ? .sheep1 : .nightSky1)
                        .font(.system(size: 16, weight: .regular, design: .default))
                        .padding(.leading, 24)
                    Spacer()
                }
            }.background(isSelected ? Color.nightSky3 : Color.sheep1)
        }
    }
}

struct MemberSearchRow_Previews: PreviewProvider {
    static var previews: some View {
        MemberSearchRow(name: "정김기", email: "test@test.com", birth: "2022.02.22", isSelected: false)
    }
}
