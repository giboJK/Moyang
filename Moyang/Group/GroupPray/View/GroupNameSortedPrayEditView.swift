//
//  GroupNameSortedPrayEditView.swift
//  Moyang
//
//  Created by 정김기보 on 2021/12/01.
//

import SwiftUI

struct GroupNameSortedPrayEditView: View {
    @ObservedObject var vm: GroupEditPrayVM
    @State private var isPraying: Bool = false
    
    var body: some View {
        VStack(spacing: 0) {
            List {
                ForEach(vm.nameItem) { item in
                    SortedPrayEditRow(vm: vm,
                                      title: item.date,
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
        .navigationBarTitle(vm.name)
        .fullScreenCover(isPresented: $isPraying, content: {
            GroupPrayingView(vm: GroupPrayingVM(groupRepo: vm.groupRepo,
                                                groupInfo: vm.groupInfo!,
                                                title: vm.prayTitle,
                                                pray: vm.prayContents,
                                                memberID: vm.memberID,
                                                memberList: vm.groupInfo?.memberList ?? []))
        })
        .navigationBarItems(trailing: EditButton())
    }
    
    func delete(at offsets: IndexSet) {
        Log.e("")
        //        users.remove(atOffsets: offsets)
    }
}

struct GroupNameSortedPrayEditView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            GroupNameSortedPrayEditView(vm: GroupEditPrayVMMock())
        }
    }
}
