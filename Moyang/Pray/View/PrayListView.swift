//
//  PrayListView.swift
//  Moyang
//
//  Created by 정김기보 on 2021/10/11.
//  Copyright © 2021 정김기보. All rights reserved.
//

import SwiftUI

struct PrayListView: View {
    @ObservedObject var vm: PrayListVM
    
    @Environment(\.presentationMode) var presentationMode
    
    @State private var newPraySubject = false
    
    var body: some View {
        NavigationLink(destination: PrayAddView(vm: PrayAddVM(prayRepo: PrayRepoImpl())),
                       isActive: $newPraySubject) { EmptyView() }
        VStack {
            List(vm.prayCardVMs, id: \.id) { prayCardVM in
                ZStack {
                    NavigationLink(destination: PrayView()) { }.opacity(0.0)
                    PrayCardView(vm: prayCardVM)
                }.listRowSeparator(.hidden)
            }
            .listStyle(.plain)
        }
        .navigationBarItems(trailing: Button(action: { newPraySubject.toggle()},
                                             label: {
            Image(systemName: "plus")
                .foregroundColor(Color.black)
        }))
        .background(Color(UIColor.sheep))
        .navigationTitle("기도 목록")
        .onLoad(perform: fetchData)
    }
    
    private func fetchData() {
        vm.fetchPrayList()
    }
}

struct PrayListView_Previews: PreviewProvider {
    static var previews: some View {
        PrayListView(vm: PrayListVM(prayRepo: PrayRepoImpl()))
    }
}
