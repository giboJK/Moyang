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
                Image(systemName: "pencil")
                    .foregroundColor(.nightSky1)
                    .padding(EdgeInsets(top: 12, leading: 0, bottom: 0, trailing: 12))
            }
            .background(
                NavigationLink(destination: GroupPrayEditView(vm: GroupEditPrayVM(groupRepo: GroupRepoImpl(service: FirestoreServiceImpl()),
                                                                                                     dateItem: item))) {}
                    .opacity(0)
            )
            Divider()
                .padding(EdgeInsets(top: 4, leading: 0, bottom: 8, trailing: 0))
            ScrollView(.vertical, showsIndicators: true) {
                ForEach(item.prayItemList, id: \.member) { item in
                    VStack {
                        HStack(spacing: 0) {
                            Text(item.member)
                                .font(.system(size: 15, weight: .regular, design: .default))
                                .foregroundColor(.nightSky1)
                                .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 8))
                                .frame(maxHeight: .infinity, alignment: .top)
                            
                            Text(item.pray)
                                .font(.system(size: 15, weight: .regular, design: .default))
                                .foregroundColor(.nightSky1)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.trailing, 16)
                        }
                    }
                    .padding(.bottom, 12)
                }
            }
        }.background(Color.sheep1)
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
