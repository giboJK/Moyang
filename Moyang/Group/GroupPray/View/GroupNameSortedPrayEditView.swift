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
                VStack(spacing: 12) {
                    ForEach(0 ..< vm.nameItem!.prayItemList.count ) { i in
                        let item = vm.nameItem.prayItemList[i]
                        HStack(spacing: 0) {
                            Text(item.date)
                                .font(.system(size: 16, weight: .regular))
                            Spacer()
                            Button(action: {
                                withAnimation {
                                    vm.nameItem.prayItemList[i].isShowing.toggle()
                                }
                            }, label: {
                                Image(systemName: vm.nameItem.prayItemList[i].isShowing ? "chevron.down" : "chevron.up")
                                    .font(.system(size: 12, weight: .regular, design: .default))
                            })
                        }
                        Divider()
                        if vm.nameItem.prayItemList[i].isShowing {
                            TextEditor(text: $vm.nameItem.prayItemList[i].pray)
                                .padding(EdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4))
                                .focused($focus)
                                .font(.system(size: 15, weight: .regular, design: .default))
                                .frame(minHeight: 64, alignment: .topLeading)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.sheep4, lineWidth: 0.5)
                                )
                        }
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
        .navigationBarTitle(vm.nameItem.name)
        .fullScreenCover(isPresented: $isPraying, content: {
            GroupPrayView(vm: GroupPrayVM(title: vm.prayTitle, pray: vm.prayContents))
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
