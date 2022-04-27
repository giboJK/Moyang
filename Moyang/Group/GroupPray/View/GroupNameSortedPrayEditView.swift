//
//  GroupNameSortedPrayEditView.swift
//  Moyang
//
//  Created by 정김기보 on 2021/12/01.
//

import SwiftUI

struct GroupNameSortedPrayEditView: View {
    @StateObject var vm: GroupEditPrayVM
    @FocusState private var focus: Bool
    @State private var isPraying: Bool = false
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView(.vertical, showsIndicators: true) {
                VStack(spacing: 16) {
                    ForEach(0 ..< vm.nameItem.count, id: \.self) { i in
                        SortedPrayEditRow(focus: _focus,
                                          title: $vm.nameItem[i].date,
                                          pray: $vm.nameItem[i].pray)
                    }
                }
            }
            .padding(EdgeInsets(top: 12, leading: 16, bottom: 4, trailing: 16))
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
            GroupPrayingView(vm: GroupPrayingVM(title: vm.prayTitle, pray: vm.prayContents))
        })
        .toolbar {
            Button("수정") {
                vm.editPray()
            }
        }
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button("완료") { focus = false }
            }
        }
    }
}

struct GroupNameSortedPrayEditView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            GroupNameSortedPrayEditView(vm: GroupEditPrayVMMock())
        }
    }
}
