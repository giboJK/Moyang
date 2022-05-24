//
//  GroupNameSortedRow.swift
//  Moyang
//
//  Created by kibo on 2022/03/07.
//

import SwiftUI

struct GroupNameSortedRow: View {
    var item: GroupPrayListVM.NameSortedItem
    var groupInfo: GroupInfo?
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                Text(item.member.name)
                    .font(.system(size: 16, weight: .semibold, design: .default))
                    .foregroundColor(.nightSky1)
                    .padding(EdgeInsets(top: 12, leading: 12, bottom: 8, trailing: 0))
                Spacer()
            }
            Divider()
                .padding(.bottom, 8)
            if let item = item.prayItemList.first {
                VStack {
                    HStack(spacing: 0) {
                        VStack(spacing: 0) {
                            Text(item.date.split(separator: " ").first ?? "")
                                .font(.system(size: 15, weight: .regular, design: .default))
                                .foregroundColor(.nightSky1)
                                .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 8))
                            Spacer()
                        }
                        
                        VStack(spacing: 0) {
                            Text(item.pray)
                                .font(.system(size: 15, weight: .regular, design: .default))
                                .foregroundColor(.nightSky1)
                                .padding(.trailing, 12)
                            Spacer()
                        }
                        
                        Spacer()
                    }
                }
            } else {
                HStack(spacing: 0) {
                    Text("기도제목을 공유해보세요 😄")
                        .font(.system(size: 15, weight: .regular, design: .default))
                        .foregroundColor(.nightSky3)
                        .padding(EdgeInsets(top: 0, leading: 12, bottom: 12, trailing: 0))
                    Spacer()
                }
            }
        }
        .background(
            NavigationLink(destination: GroupNameSortedPrayEditView(vm: GroupEditPrayVM(groupRepo: GroupRepoImpl(service: FSServiceImpl()),
                                                                                        nameItem: item,
                                                                                        groupInfo: groupInfo))) {}
                .opacity(0)
        )
        .background(Color.sheep1)
        .cornerRadius(12)
    }
}
