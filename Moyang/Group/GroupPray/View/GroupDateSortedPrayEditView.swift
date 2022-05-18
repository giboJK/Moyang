//
//  GroupDateSortedPrayEditView.swift
//  Moyang
//
//  Created by 정김기보 on 2022/04/19.
//

import SwiftUI

struct GroupDateSortedPrayEditView: View {
    @StateObject var vm: GroupEditPrayVM
    @State private var isPraying: Bool = false
    
    var body: some View {
        VStack(spacing: 0) {
            List {
                ForEach(vm.dateItem) { item in
                    SortedPrayEditRow(vm: vm,
                                      prayId: item.id,
                                      title: item.member,
                                      pray: item.pray)
                    .listRowSeparator(.hidden)
                }
                .onDelete(perform: delete)
                .listRowBackground(Color.clear)
            }
            .listStyle(.plain)
            .padding(EdgeInsets(top: 12, leading: 0, bottom: 8, trailing: 0))
            .foregroundColor(.nightSky1)
            
            Spacer()
            Button(action: {
                isPraying.toggle()
            }) {
                Text("기도하기")
            }
            .buttonStyle(MoyangButtonStyle(.black,
                                           width: 100,
                                           height: 48))
            .padding(.bottom, 12)
        }
        .frame(maxWidth: .infinity)
        .background(Color.sheep1)
        .navigationBarTitle(vm.date)
        .fullScreenCover(isPresented: $isPraying, content: {
            GroupPrayingView(vm: GroupPrayingVM(groupRepo: vm.groupRepo,
                                                groupInfo: vm.groupInfo!,
                                                title: vm.prayTitle,
                                                pray: vm.prayContents,
                                                dateID: vm.date,
                                                dateItemList: vm.dateItemList))
        })
        .navigationBarItems(trailing: EditButton())
    }
    
    func delete(at offsets: IndexSet) {
        Log.e("")
        //        users.remove(atOffsets: offsets)
    }
}

struct GroupDateSortedPrayEditView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            GroupDateSortedPrayEditView(vm: GroupEditPrayVMMock())
        }
    }
}
