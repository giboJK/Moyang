//
//  CommunityList.swift
//  Moyang
//
//  Created by 정김기보 on 2022/04/05.
//

import SwiftUI

struct CommunityList: View {
    @StateObject var vm = CommunityListVM()
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                Text("교회")
                    .padding(.leading, 28)
            }
            List {
                ForEach(vm.itemList) { item in
                    CommunityListRow(item: item)
                        .listRowSeparator(.hidden)
                }
                .listRowBackground(Color.clear)
            }.padding(EdgeInsets(top: 8, leading: 0, bottom: 72, trailing: 0))
                .listStyle(.plain)
        }
        .frame(maxWidth: .infinity)
        .background(Color.sheep3)
        .navigationTitle("공동체")
    }
}

struct CommunityList_Previews: PreviewProvider {
    static var previews: some View {
        CommunityList()
    }
}

struct CommunityListRow: View {
    var item: CommunityListVM.CommunityListItem
    var body: some View {
        HStack(spacing: 0) {
            Text("교회")
                .padding(.leading, 28)
        }
        .frame(maxWidth: .infinity)
        .background(Color.sheep1)
    }
}
