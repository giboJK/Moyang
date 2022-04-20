//
//  GroupPrayList.swift
//  Moyang
//
//  Created by 정김기보 on 2021/11/21.
//

import SwiftUI

struct GroupPrayList: View {
    @StateObject var vm: GroupPrayListVM
    @State private var showingNewGroupPrayView = false
    @State private var showingNewMyPrayView = false
    
    var body: some View {
            VStack(spacing: 0) {
                HStack(spacing: 0) {
                    Button {
                        vm.changeSorting()
                    } label: {
                        Image(uiImage: Asset.Images.Cell.sortDown.image)
                            .resizable()
                            .frame(width: 16.0, height: 16.0)
                        let title = vm.showSortingByName ? "이름순" : "날짜순"
                        Text(title)
                            .foregroundColor(.nightSky1)
                            .font(.system(size: 16, weight: .semibold, design: .default))
                    }
                    .foregroundColor(Color.nightSky1)
                    Spacer()
                    NavigationLink(destination: NewGroupPrayView(vm: NewGroupPrayVM(repo: GroupRepoImpl(service: FSServiceImpl()),
                                                                                    groupInfo: vm.groupInfo)),
                                   isActive: $showingNewGroupPrayView) {
                        Button(action: {
                            showingNewGroupPrayView = true
                        }) {
                            Text("그룹 기도 ") + Text(Image(systemName: "plus"))
                        }
                        .buttonStyle(MoyangButtonStyle(.secondary,
                                                       width: 100,
                                                       height: 24))
                    }
                                   .padding(.trailing, 8)
                    NavigationLink(destination: NewGroupPrayView(vm: NewGroupPrayVM(repo: GroupRepoImpl(service: FSServiceImpl()),
                                                                                    groupInfo: vm.groupInfo)),
                                   isActive: $showingNewMyPrayView) {
                        Button(action: {
                            showingNewMyPrayView = true
                        }) {
                            Text("내 기도 ") + Text(Image(systemName: "plus"))
                        }
                        .buttonStyle(MoyangButtonStyle(.secondary,
                                                       width: 84,
                                                       height: 24))
                    }
                                   .padding(.trailing, 16)
                }
                .padding(EdgeInsets(top: 32, leading: 24, bottom: 12, trailing: 0))
                .frame(height: 24, alignment: .leading)
                
                if vm.showSortingByName {
                    List {
                        ForEach(vm.nameItemList) { item in
                            GroupNameSortedRow(item: item)
                                .frame(maxHeight: 160)
                                .listRowSeparator(.hidden)
                        }
                        .listRowBackground(Color.clear)
                    }
                    .padding(EdgeInsets(top: 12, leading: 0, bottom: 0, trailing: 0))
                    .listStyle(.plain)
                } else {
                    List {
                        ForEach(vm.dateItemList, id: \.date) { item in
                            GroupDateSortedRow(item: item)
                                .listRowSeparator(.hidden)
                        }
                        .listRowBackground(Color.clear)
                    }
                    .padding(EdgeInsets(top: 12, leading: 0, bottom: 0, trailing: 0))
                    .listStyle(.plain)
                }
            }
        .frame(maxWidth: .infinity)
        .background(Color.sheep2)
        .navigationBarTitle("기도제목")
    }
}

struct CellPrayListView_Previews: PreviewProvider {
    static var previews: some View {
        GroupPrayList(vm: GroupPrayListVMMock())
    }
}
