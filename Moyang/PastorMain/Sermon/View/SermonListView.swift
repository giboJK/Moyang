//
//  SermonListView.swift
//  Moyang
//
//  Created by 정김기보 on 2022/02/16.
//

import SwiftUI
import Combine

struct SermonListView: View {
    @StateObject var vm: SermonListVM
    
    var body: some View {
        ZStack {
            List {
                ForEach(vm.itemList) { item in
                    SermonPreviewCard(item: item)
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
                    NavigationLink(destination: NavigationLazyView(NewSermonView())) {
                        Image(systemName: "plus")
                    }
                }
                .buttonStyle(MoyangButtonStyle(.black,
                                               width: 80,
                                               height: 52))
                .padding(.bottom, 10)
                .listRowSeparator(.hidden, edges: .all)
            }
        }
        .navigationTitle("설교 목록")
        .frame(maxWidth: .infinity)
        .background(Color.sheep2)
    }
    
    func deleteItems(at offsets: IndexSet) {
        vm.itemList.remove(atOffsets: offsets)
    }
}

struct SermonListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SermonListView(vm: SermonListVMMock())
        }
    }
}
