//
//  GroupDateSortedRow.swift
//  Moyang
//
//  Created by kibo on 2022/03/07.
//

import SwiftUI

struct GroupDateSortedRow: View {
    var item: GroupPrayListVM.DateSortedItem
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text(item.date)
                    .font(.system(size: 16, weight: .semibold, design: .default))
                    .foregroundColor(.nightSky1)
                    .padding(EdgeInsets(top: 12, leading: 12, bottom: 0, trailing: 0))
                Spacer()
            }
            Divider()
                .padding(EdgeInsets(top: 4, leading: 0, bottom: 8, trailing: 0))
            HStack(spacing: 0) {
                Text("\(item.count)명의 기도제목이 있습니다.")
                    .font(.system(size: 15, weight: .regular, design: .default))
                    .foregroundColor(.nightSky1)
                    .padding(EdgeInsets(top: 0, leading: 12, bottom: 12, trailing: 0))
                Spacer()
            }
        }
        .background(
            NavigationLink(destination: GroupPrayEditView(vm: GroupEditPrayVM(groupRepo: GroupRepoImpl(service: FSServiceImpl()),
                                                                              dateItem: item))) {}
                .opacity(0)
        )
        .background(Color.sheep1)
        .cornerRadius(12)
    }
}

struct GroupDateSortedRow_Previews: PreviewProvider {
    static var previews: some View {
        GroupDateSortedRow(item: GroupPrayListVM.DateSortedItem(date: "2022.03.03",
                                                                prayItemList: [GroupMemberPray(member: Member(id: UUID().uuidString,
                                                                                                              name: "테스트",
                                                                                                              email: "test@test.com",
                                                                                                              profileURL: ""),
                                                                                               pray: "기도 제목오오옥")]))
    }
}
