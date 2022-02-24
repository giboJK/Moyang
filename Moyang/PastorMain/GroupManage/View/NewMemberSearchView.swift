//
//  NewMemberSearchView.swift
//  Moyang
//
//  Created by 정김기보 on 2022/02/20.
//

import SwiftUI

struct NewMemberSearchView: View {
    var title: String
    @StateObject var vm: AddNewGroupVM
    
    @State private var searchText = ""
    @State private var isEditing = false
    
    
    var body: some View {
        VStack {
            SearchBar(text: $searchText, isEditing: $isEditing)
                .padding(EdgeInsets(top: 8, leading: 12, bottom: 8, trailing: 12))
            List(vm.itemList.filter { searchText.isEmpty ? true : $0.name.contains(searchText) }) { item in
                MemberSearchRow(name: item.name,
                                email: item.email,
                                birth: item.birth,
                                isSelected: item.isSelected)
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.clear)
                    .gesture(
                        TapGesture()
                            .onEnded({ _ in
                                vm.toggleMemberSelection(item: item)
                            })
                    )
            }
            .listStyle(.plain)
        }
        .navigationTitle(title)
        .navigationBarHidden(isEditing)
        .background(Color.sheep2)
        .preferredColorScheme(.light)
        .animation(.linear(duration: 0.25), value: isEditing)
        .toolbar {
            Button("확인(\(vm.count))") {
                Log.d("확인")
            }
        }
    }
}

struct NewMemberSearchView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            NewMemberSearchView(title: "리더 추가", vm: AddNewGroupVMMock())
        }
    }
}
