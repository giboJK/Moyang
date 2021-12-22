//
//  CellPreviewCard.swift
//  Moyang
//
//  Created by 정김기보 on 2021/10/09.
//  Copyright © 2021 정김기보. All rights reserved.
//

import SwiftUI

struct CellPreviewCard: View {
    @ObservedObject var vm: CellCardVM
    
    var body: some View {
        VStack {
            HStack {
                Text(vm.cellPreview.cellName)
                    .font(.system(size: 16, weight: .bold, design: .default))
                    .frame(alignment: .center)
                Spacer()
                Image(systemName: "arrow.forward")
            }
            .padding(.top, 10)
            Divider().padding(-5)
            HStack {
                Text(vm.cellPreview.talkingSubject)
                    .font(.system(size: 14, weight: .regular, design: .default))
                    .frame(maxWidth: .infinity, alignment: .topLeading)
                Spacer()
            }.padding(.top, -5)
            HStack(spacing: -8) {
                ForEach(vm.randomMemberList) { member in
                    if let profileURL = member.profileURL {
                        AsyncImage(url: URL(string: profileURL))
                            .scaledToFill()
                            .frame(width: 40, height: 40, alignment: .center)
                            .cornerRadius(13)
                    } else {
                        Text(String(member.name.first ?? Character("")))
                            .frame(width: 40, height: 40, alignment: .center)
                            .background(Color(UIColor.bgColor))
                            .cornerRadius(13)
                            .overlay(
                                RoundedRectangle(cornerRadius: 13)
                                    .stroke(Color(Asset.Colors.Dessert.desertStone.color), lineWidth: 1)
                            ).padding(.top, 1)
                    }
                }
                .padding(.bottom, 10)
                Spacer()
                if vm.cellPreview.memberList.count - vm.maxDisplayedMembers > 0 {
                    Image(systemName: "person.fill")
                        .padding(.trailing, 25)
                        .padding(.bottom, 10)
                        .frame(width: 10, height: 10)
                    Text("+\(vm.cellPreview.memberList.count - 5)")
                        .padding(.bottom, 10)
                }
            }.frame(height: 45)
        }
        .modifier(MainCard())
        .eraseToAnyView()
    }
}
