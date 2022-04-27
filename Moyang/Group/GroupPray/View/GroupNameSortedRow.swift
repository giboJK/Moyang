//
//  GroupNameSortedRow.swift
//  Moyang
//
//  Created by kibo on 2022/03/07.
//

import SwiftUI

struct GroupNameSortedRow: View {
    var item: GroupPrayListVM.NameSortedItem
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                Text(item.name)
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
                                                                                        nameItem: item))) {}
                .opacity(0)
        )
        .background(Color.sheep1)
        .cornerRadius(12)
    }
}

struct GroupNameSortedRow_Previews: PreviewProvider {
    static var previews: some View {
        GroupNameSortedRow(item: GroupPrayListVM.NameSortedItem(member: Member(id: "",
                                                                               name: "ds",
                                                                               email: "sadasd",
                                                                               profileURL: "",
                                                                               auth: ""),
                                                                dateList: ["2022.03.01",
                                                                           "2022.03.03",
                                                                           "2022.03.05"],
                                                                prayList: ["기도제목 11",
                                                                           "기도제목 2222",
                                                                           "정말로 너무너무 길다랗고 길다란 기도제목입니다아아아~~ 112345"]))
    }
}
