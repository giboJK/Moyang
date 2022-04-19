//
//  GroupManageListView.swift
//  Moyang
//
//  Created by 정김기보 on 2022/02/18.
//

import SwiftUI

struct GroupManageListView: View {
    @ObservedObject var vm: GroupManageListVM
    
    var body: some View {
        ZStack {
            List {
                ForEach(vm.itemList) { item in
                    GroupManageCardRow(item: item)
                        .listRowSeparator(.hidden)
                }
                .onDelete(perform: deleteItems)
                .listRowBackground(Color.clear)
            }.padding(EdgeInsets(top: 8, leading: 0, bottom: 72, trailing: 0))
                .listStyle(.plain)
            
            VStack(spacing: 0) {
                Spacer()
                Button(action: {
                }) {
                    NavigationLink(destination: NavigationLazyView(AddNewGroupView(vm: AddNewGroupVM()))) {
                        Image(systemName: "plus")
                    }
                }
                .buttonStyle(MoyangButtonStyle(.black,
                                               width: 80,
                                               height: 48))
                .padding(.bottom, 10)
                .listRowSeparator(.hidden, edges: .all)
            }
        }
        .navigationTitle("공동체 그룹")
        .frame(maxWidth: .infinity)
        .background(Color.sheep2)
    }
    
    func deleteItems(at offsets: IndexSet) {
        vm.itemList.remove(atOffsets: offsets)
    }
}

struct GroupManageListView_Previews: PreviewProvider {
    static var previews: some View {
        GroupManageListView(vm: GroupManageListVMMock())
    }
}
