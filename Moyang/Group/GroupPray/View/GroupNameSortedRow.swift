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
            HStack {
                Text(item.name)
                    .font(.system(size: 16, weight: .semibold, design: .default))
                    .foregroundColor(.nightSky1)
                    .padding(EdgeInsets(top: 12, leading: 12, bottom: 0, trailing: 0))
                Spacer()
                Image(systemName: "pencil")
                    .foregroundColor(.nightSky1)
                    .padding(EdgeInsets(top: 12, leading: 0, bottom: 0, trailing: 12))
            }
            .background(
                NavigationLink(destination: NavigationLazyView(GroupPrayEditView(vm: GroupEditPrayVM(groupRepo: GroupRepoImpl(service: FirestoreServiceImpl()),
                                                                                                     nameItem: item)))) {}
                    .opacity(0)
            )
            Divider()
                .padding(EdgeInsets(top: 4, leading: 0, bottom: 8, trailing: 0))
            ScrollView(.vertical, showsIndicators: true) {
                ForEach(item.prayItemList, id: \.date) { item in
                    VStack {
                        HStack(spacing: 0) {
                            Text(item.date.split(separator: " ").first ?? "")
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

struct GroupNameSortedRow_Previews: PreviewProvider {
    static var previews: some View {
        GroupNameSortedRow(item: GroupPrayListVM.NameSortedItem(id: UUID().uuidString,
                                                                name: "이름A",
                                                                dateList: ["2022.03.01",
                                                                           "2022.03.03",
                                                                           "2022.03.05"],
                                                                prayList: ["기도제목 11",
                                                                           "기도제목 2222",
                                                                           "정말로 너무너무 길다랗고 길다란 기도제목입니다아아아~~ 112345"]))
    }
}
