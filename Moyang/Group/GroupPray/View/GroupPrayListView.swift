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
        ZStack {
            VStack {
                HStack {
                    Button {
                        vm.changeSorting()
                    } label: {
                        Image(uiImage: Asset.Images.Cell.sortDown.image)
                            .resizable()
                            .frame(width: 16.0, height: 16.0)
                        let title = vm.showSortingByName ? "이름순" : "날짜순"
                        Text(title)
                            .foregroundColor(.nightSky1)
                            .font(.system(size: 16, weight: .regular, design: .default))
                    }
                    .foregroundColor(Color.nightSky1)
                    .padding(.leading, 15)
                    Spacer()
                }
                .padding(.top, 10)
                .frame(height: 16, alignment: .leading)
                
                if vm.showSortingByName {
                    List {
                        ForEach(vm.nameItemList, id: \.name) { item in
                            HStack {
                                Text(item.name.split(separator: "_").first!)
                                    .font(.system(size: 16, weight: .semibold, design: .default))
                                    .foregroundColor(.nightSky1)
                                Spacer()
                                Image(systemName: "pencil")
                                    .foregroundColor(.nightSky1)
                            }
                            .background(
                                NavigationLink(destination: GroupPrayEditView(vm: GroupEditPrayVM(groupRepo: groupRepo, nameItem: item))) {}
                                    .opacity(0)
                            )
                            ScrollView(.vertical, showsIndicators: true) {
                                ForEach(item.prayItemList, id: \.date) { item in
                                    CellPrayListRow(info: item.date, pray: item.pray)
                                        .padding(.bottom, 10)
                                }
                            }
                            .frame(maxHeight: 160)
                        }
                        .listRowBackground(Color.clear)
                    }
                    .padding(EdgeInsets(top: 8, leading: 0, bottom: 72, trailing: 0))
                    .listStyle(.plain)
                } else {
                    List {
                        ForEach(vm.dateItemList, id: \.date) { item in
                            HStack {
                                Text(item.date)
                                    .font(.system(size: 16, weight: .semibold, design: .default))
                                    .foregroundColor(.nightSky1)
                                Spacer()
                                Image(systemName: "pencil")
                                    .foregroundColor(.nightSky1)
                            }
                            .background(NavigationLink(destination: GroupPrayEditView(vm: GroupEditPrayVM(groupRepo: groupRepo, dateItem: item))) {}
                                            .opacity(0))
                            ScrollView(.vertical, showsIndicators: true) {
                                ForEach(item.prayItemList, id: \.member) { item in
                                    CellPrayListRow(info: item.member, pray: item.pray)
                                        .padding(.bottom, 10)
                                }
                            }
                            .frame(maxHeight: 160)
                        }
                        .listRowBackground(Color.clear)
                    }
                    .padding(EdgeInsets(top: 8, leading: 0, bottom: 72, trailing: 0))
                    .listStyle(.plain)
                }
            }
            VStack(spacing: 0) {
                Spacer()
                Button(action: {
                }) {
                    NavigationLink(destination: NewGroupPrayView(vm: NewGroupPrayVM(repo: GroupRepoImpl(service: FirestoreServiceImpl())))) {
                        Image(systemName: "plus")
                    }
                }
                .buttonStyle(MoyangButtonStyle(.black,
                                               width: 80,
                                               height: 50))
                .padding(.bottom, 10)
                .listRowSeparator(.hidden, edges: .all)
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
        GroupPrayListView(vm: GroupPrayListVMMock())
    }
}
