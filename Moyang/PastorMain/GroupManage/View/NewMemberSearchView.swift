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
    
    @State private var showingAlert = false
    
    @State private var searchText = ""
    @State private var isEditing = false
    @State private var alertItem: AddNewGroupVM.SearchMemberItem!
    
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
                                if isLeaderSelectionMode {
                                    if item.isMember {
                                        self.alertItem = item
                                        showingAlert.toggle()
                                    } else {
                                        vm.toggleLeaderSelection(item: item)
                                    }
                                } else {
                                    if item.isLeader {
                                        self.alertItem = item
                                        showingAlert.toggle()
                                    } else {
                                        vm.toggleMemberSelection(item: item)
                                    }
                                }
                            })
                    )
            }
                    .listStyle(.plain)
        }
        .alert(isPresented: $showingAlert) {
            let title = isLeaderSelectionMode ? "리더로 변경" : "멤버로 변경"
            var message = "\(alertItem.name)님의 상태를 정말로 변경하시겠어요?"
            message += isLeaderSelectionMode ? " 멤버는 자동 취소됩니다." : " 리더는 자동 취소됩니다."
            
            return Alert(title: Text(title),
                         message: Text(message),
                         primaryButton: .default(Text("변경"), action: {
                if isLeaderSelectionMode {
                    vm.toggleLeaderSelection(item: alertItem)
                } else {
                    vm.toggleMemberSelection(item: alertItem)
                }
            }), secondaryButton: .cancel())
        }
        .navigationTitle(isLeaderSelectionMode ? "리더 추가" : "구성원 추가")
        .background(Color.sheep1)
    }
}

struct NewMemberSearchView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            NewMemberSearchView(isLeaderSelectionMode: true, vm: AddNewGroupVMMock())
        }
    }
}
