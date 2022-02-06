//
//  CommunityGroupCardView.swift
//  Moyang
//
//  Created by kibo on 2022/02/05.
//

import SwiftUI

struct CommunityGroupCardView: View {
    @ObservedObject var vm: CommunityGroupCardVM
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text(vm.item.groupName)
                Spacer()
                Image(systemName: "chevron.right")
            }
            VStack(spacing: 0) {
                HStack {
                    Text("2022.01.30 나눔질문")
                    Spacer()
                    Text("1 / 4")
                }
                Divider()
                Text("· 오늘 본문을 보면서")
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text("· 귀신들린")
                    .frame(maxWidth: .infinity, alignment: .leading)
                HStack {
                    Text("2022.01.30 기도")
                    Spacer()
                    Text("Last pray date: 2022.01.31")
                }.padding(.top, 20)
                Divider()
                Text("· 정김기보: 부끄부끄")
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text("· 정김기보: 안 부끄부끄로")
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .modifier(MainCard())
            .eraseToAnyView()
        }
    }
}

struct CommunityGroupCardView_Previews: PreviewProvider {
    static var previews: some View {
        CommunityGroupCardView(vm: CommunityGroupCardVMMock())
    }
}
