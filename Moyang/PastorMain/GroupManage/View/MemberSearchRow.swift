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
    var isLeaderSelectionMode: Bool
    var isLeader: Bool
    var isMember: Bool
    
    var body: some View {
        if isLeaderSelectionMode {
            let fontColor = isMember ? Color.sheep4 : Color.nightSky1
            HStack(spacing: 0) {
                if isLeader {
                    Image(systemName: "checkmark.circle.fill")
                        .tint(.nightSky3)
                        .padding(.trailing, 8)
                }
                VStack(spacing: 0) {
                    HStack(spacing: 0) {
                        Text(name)
                            .foregroundColor(isLeader ? .ydGreen1 : fontColor)
                            .font(.system(size: 16, weight: .regular, design: .default))
                        
                        Spacer()
                        Text(birth)
                            .foregroundColor(isLeader ? .ydGreen1 : fontColor)
                            .font(.system(size: 16, weight: .regular, design: .default))
                            .padding(.trailing, 20)
                    }
                    .padding(.bottom, 4)
                    Text(email)
                        .foregroundColor(isLeader ? .ydGreen1 : fontColor)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.system(size: 16, weight: .regular, design: .default))
                        .padding(.bottom, 4)
                    
                    if isMember {
                        Text("멤버로 선택됨")
                            .foregroundColor(fontColor)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .font(.system(size: 14, weight: .regular, design: .default))
                    }
                }.background(Color.sheep1)
            }
            .padding(.leading, 20)
        } else {
            let fontColor = isLeader ? Color.sheep4 : Color.nightSky1
            HStack(spacing: 0) {
                if isMember {
                    Image(systemName: "checkmark.circle.fill")
                        .tint(.nightSky3)
                        .padding(.trailing, 8)
                }
                VStack(spacing: 0) {
                    HStack(spacing: 0) {
                        Text(name)
                            .foregroundColor(isMember ? .ydGreen1 : fontColor)
                            .font(.system(size: 16, weight: .regular, design: .default))
                        
                        Spacer()
                        Text(birth)
                            .foregroundColor(isMember ? .ydGreen1 : fontColor)
                            .font(.system(size: 16, weight: .regular, design: .default))
                            .padding(.trailing, 20)
                    }
                    .padding(.bottom, 4)
                    Text(email)
                        .foregroundColor(isMember ? .ydGreen1 : fontColor)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.system(size: 16, weight: .regular, design: .default))
                        .padding(.bottom, 4)
                    
                    if isLeader {
                        Text("리더로 선택됨")
                            .foregroundColor(fontColor)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .font(.system(size: 14, weight: .regular, design: .default))
                    }
                }.background(Color.sheep1)
            }
            .padding(.leading, 20)
        }
    }
}

struct MemberSearchRow_Previews: PreviewProvider {
    static var previews: some View {
        MemberSearchRow(name: "정김기",
                        email: "test@test.com",
                        birth: "2022.02.22",
                        isLeaderSelectionMode: true,
                        isLeader: false,
                        isMember: true)
    }
}
