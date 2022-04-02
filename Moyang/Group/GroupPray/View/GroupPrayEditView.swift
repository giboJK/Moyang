//
//  GroupPrayEditView.swift
//  Moyang
//
//  Created by 정김기보 on 2021/12/01.
//

import SwiftUI

struct GroupPrayEditView: View {
    @ObservedObject var vm: GroupEditPrayVM
    @FocusState private var focus: Bool
    @State private var isPraying: Bool = false
    
    var body: some View {
        ZStack {
            ScrollView(.vertical, showsIndicators: true) {
                VStack(spacing: 0) {
                    if vm.isNameEdit {
                        ForEach(0 ..< vm.nameItem.prayItemList.count ) { i in
                            Text(vm.nameItem.prayItemList[i].date)
                                .font(.system(size: 16, weight: .regular, design: .default))
                                .foregroundColor(.nightSky1)
                                .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 20))
                                .frame(maxWidth: .infinity, alignment: .leading)
                            Divider()
                                .padding(.leading, 16)
                                .frame(height: 1)
                            TextEditor(text: $vm.nameItem.prayItemList[i].pray)
                                .focused($focus)
                                .font(.system(size: 16, weight: .regular, design: .default))
                                .frame(maxHeight: 72, alignment: .topLeading)
                                .foregroundColor(.nightSky1)
                                .padding(EdgeInsets(top: 0, leading: 20, bottom: 8, trailing: 20))
                        }
                    } else {
                        ForEach(0 ..< vm.dateItem!.prayItemList.count ) { i in
                            Text(vm.dateItem.prayItemList[i].member)
                                .font(.system(size: 16, weight: .regular, design: .default))
                                .foregroundColor(.nightSky1)
                                .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 20))
                                .frame(maxWidth: .infinity, alignment: .leading)
                            Divider()
                                .padding(.leading, 16)
                                .frame(height: 1)
                            TextEditor(text: $vm.dateItem.prayItemList[i].pray)
                                .focused($focus)
                                .font(.system(size: 16, weight: .regular, design: .default))
                                .frame(maxHeight: 72, alignment: .topLeading)
                                .foregroundColor(.nightSky1)
                                .padding(EdgeInsets(top: 0, leading: 20, bottom: 8, trailing: 20))
                        }
                    }
                }
                Spacer()
            }
            .padding(.top, 12)
            
            VStack(spacing: 0) {
                Spacer()
                Button(action: {
                    isPraying.toggle()
                }) {
                        Text("기도하기")
                }
                .buttonStyle(MoyangButtonStyle(.black,
                                               width: 100,
                                               height: 50))
                .padding(.bottom, 10)
            }
        }
        .frame(maxWidth: .infinity)
        .background(Color.sheep1)
        .navigationBarTitle(vm.isNameEdit ? vm.nameItem.name : vm.dateItem.date)
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

struct CellMemberPrayEditView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            GroupPrayEditView(vm: GroupEditPrayVMMock())
        }
    }
}
