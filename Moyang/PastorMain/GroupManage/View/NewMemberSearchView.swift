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
    
    let countryList = Locale.isoRegionCodes
        .compactMap { Locale.current.localizedString(forRegionCode: $0) }
    
    var body: some View {
        List {
            Section.init(header: SearchBar(text: $searchText, isEditing: $isEditing),
                         content: {
                ForEach(countryList
                            .filter { searchText.isEmpty ? true : $0.contains(searchText) },
                        id: \.self) { country in
                    Text(country)
                        .listRowSeparator(.hidden)
                }
                    .listRowBackground(Color.clear)
            })
        }
        .listStyle(.plain)
        .navigationTitle(title)
        .navigationBarHidden(isEditing)
        .background(Color.sheep2)
        .animation(.linear(duration: 0.25), value: isEditing)
        .toolbar {
            Button("확인") {
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
