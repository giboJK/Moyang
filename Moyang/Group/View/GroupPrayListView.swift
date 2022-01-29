//
//  GroupPrayListView.swift
//  Moyang
//
//  Created by 정김기보 on 2021/11/21.
//

import SwiftUI

struct GroupPrayListView: View {
    @ObservedObject var vm: GroupPrayListVM
    private let groupRepo = GroupRepoImpl(service: FirestoreServiceImpl())
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    vm.changeSorting()
                } label: {
                    Image(uiImage: Asset.Images.Cell.sortDown.image)
                        .resizable()
                        .frame(width: 16.0, height: 16.0)
                    vm.showSortingByName ? Text("이름순") : Text("날짜순")
                }
                .foregroundColor(Color.wilderness1)
                .padding(.leading, 15)
                Spacer()
            }
            .padding(.top, 10)
            .frame(height: 16, alignment: .leading)
            if vm.showSortingByName {
                List(vm.nameItemList, id: \.name) { item in
                    HStack {
                        Text(item.name.split(separator: "_").first!)
                        Spacer()
                        Image(systemName: "pencil")
                    }
                    .background(
                        NavigationLink(destination: GroupPrayEditView(vm: GroupEditPrayVM(groupRepo: groupRepo, nameItem: item))) {}
                            .opacity(0)
                    )
                    .buttonStyle(PlainButtonStyle())
                    ScrollView(.vertical, showsIndicators: true) {
                        ForEach(item.prayItemList, id: \.date) { item in
                            CellPrayListRow(info: item.date, pray: item.pray)
                                .padding(.bottom, 10)
                        }
                    }
                    .frame(maxHeight: 160)
                }
                .listStyle(PlainListStyle())
            } else {
                List(vm.dateItemList, id: \.date) { item in
                    HStack {
                        Text(item.date)
                        Spacer()
                        Image(systemName: "pencil")
                    }
                    .background(
                        NavigationLink(destination: GroupPrayEditView(vm: GroupEditPrayVM(groupRepo: groupRepo, dateItem: item))) {}
                            .opacity(0)
                    )
                    ScrollView(.vertical, showsIndicators: true) {
                        ForEach(item.prayItemList, id: \.member) { item in
                            CellPrayListRow(info: item.member, pray: item.pray)
                                .padding(.bottom, 10)
                        }
                    }
                    .frame(maxHeight: 160)
                }
                .listStyle(PlainListStyle())
            }
        }
        .frame(maxWidth: .infinity)
        .background(Color.sheep1)
        .navigationBarTitle("기도제목")
        .onAppear {
            vm.loadData()
        }
    }
}

struct CellPrayListView_Previews: PreviewProvider {
    static var previews: some View {
        GroupPrayListView(vm: GroupPrayListVM(groupRepo: GroupRepoImpl(service: FirestoreServiceImpl())))
    }
}
