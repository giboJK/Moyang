//
//  GroupManageCardRow.swift
//  Moyang
//
//  Created by 정김기보 on 2022/02/19.
//

import SwiftUI

struct GroupManageCardRow: View {
    var item: GroupManageListVM.GroupItem
    var body: some View {
        VStack(spacing: 0) {
            Text(item.name)
                .font(.system(size: 16, weight: .semibold, design: .default))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(EdgeInsets(top: 0, leading: 12, bottom: 8, trailing: 8))
            
            VStack(spacing: 4) {
                HStack(spacing: 0) {
                    Text("리더")
                        .frame(width: 56, alignment: .leading)
                        .foregroundColor(.nightSky1)
                        .font(.system(size: 15, weight: .regular, design: .default))
                        .padding(EdgeInsets(top: 0, leading: 12, bottom: 0, trailing: 8))
                    Text(item.leader.name)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundColor(.nightSky1)
                        .font(.system(size: 15, weight: .regular, design: .default))
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 12))
                }
                .padding(.top, 8)
                HStack(spacing: 0) {
                    Text("구성원")
                        .frame(width: 56, alignment: .leading)
                        .foregroundColor(.nightSky1)
                        .font(.system(size: 15, weight: .regular, design: .default))
                        .padding(EdgeInsets(top: 0, leading: 12, bottom: 0, trailing: 8))
                    Text(item.leader.name)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundColor(.nightSky1)
                        .font(.system(size: 15, weight: .regular, design: .default))
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 12))
                }
                .padding(.bottom, 8)
            }
            .background(Color.sheep1)
            .cornerRadius(8)
            
        }
    }
}

struct GroupManageCardRow_Previews: PreviewProvider {
    static var previews: some View {
        GroupManageCardRow(item: GroupManageListVM.GroupItem(groupInfo: GroupInfo(id: UUID().uuidString,
                                                                                  createdDate: Date().toString("yyyy.MM.dd"),
                                                                                  groupName: "깐부셀",
                                                                                  parentGroup: UUID().uuidString,
                                                                                  leaderList: [Member(id: UUID().uuidString,
                                                                                                      name: "조경환",
                                                                                                      email: "test@test.com",
                                                                                                      profileURL: "")],
                                                                                  memberList: [Member(id: UUID().uuidString,
                                                                                                      name: "길지윤",
                                                                                                      email: "test@test.com",
                                                                                                      profileURL: ""),
                                                                                               Member(id: UUID().uuidString,
                                                                                                      name: "정김기",
                                                                                                      email: "test@test.com",
                                                                                                      profileURL: ""),
                                                                                               Member(id: UUID().uuidString,
                                                                                                      name: "김기보",
                                                                                                      email: "test@test.com",
                                                                                                      profileURL: "")])))
    }
}