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
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                Text(name)
                    .foregroundColor(.nightSky1)
                    .font(.system(size: 16, weight: .regular, design: .default))
                    .padding(.leading, 24)
                Spacer()
                Text(birth)
                    .foregroundColor(.nightSky1)
                    .font(.system(size: 16, weight: .regular, design: .default))
                    .padding(.trailing, 24)
            }
            HStack(spacing: 0) {
                Text(email)
                    .foregroundColor(.nightSky1)
                    .font(.system(size: 16, weight: .regular, design: .default))
                    .padding(.leading, 24)
                Spacer()
            }
        }
    }
}

struct MemberSearchRow_Previews: PreviewProvider {
    static var previews: some View {
        MemberSearchRow(name: "정김기", email: "test@test.com", birth: "2022.02.22")
    }
}
