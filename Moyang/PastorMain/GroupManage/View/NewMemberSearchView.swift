//
//  NewMemberSearchView.swift
//  Moyang
//
//  Created by 정김기보 on 2022/02/20.
//

import SwiftUI

struct NewMemberSearchView: View {
    var isLeaderSelectionMode: Bool
    @StateObject var vm: AddNewGroupVM
    
    @State private var searchText = ""
    @State private var isEditing = false
    
    var body: some View {
        let itemList = isLeaderSelectionMode ? vm.leaderItemList : vm.memberItemList
        VStack(spacing: 0) {
            SearchBar(text: $searchText, isEditing: $isEditing)
                .padding(EdgeInsets(top: 8, leading: 12, bottom: 4, trailing: 12))
            Divider()
                .padding(.bottom, 4)
                .foregroundColor(.sheep4)
            List(itemList
                    .filter { searchText.isEmpty ? true : $0.name.contains(searchText) }) { item in
                MemberSearchRow(name: item.name,
                                email: item.email,
                                birth: item.birth,
                                isLeaderSelectionMode: isLeaderSelectionMode,
                                isLeader: item.isLeader,
                                isMember: item.isMember)
                    .listRowBackground(Color.sheep1)
                    .listRowInsets(EdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0))
                    .gesture(
                        TapGesture()
                            .onEnded({ _ in
                                vm.toggleMemberSelection(item: item)
                            })
                    )
            }
                    .listStyle(.plain)
        }
        .navigationTitle(isLeaderSelectionMode ? "리더 추가" : "구성원 추가")
        .background(Color.sheep1)
        .preferredColorScheme(.light)
        .toolbar {
            let count: Int = isLeaderSelectionMode ? vm.leaderCount : vm.membercount
            Button("확인(\(count))") {
                Log.d("확인")
            }
        }
    }
}

struct NewMemberSearchView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            NewMemberSearchView(isLeaderSelectionMode: true, vm: AddNewGroupVMMock())
        }
    }
}
