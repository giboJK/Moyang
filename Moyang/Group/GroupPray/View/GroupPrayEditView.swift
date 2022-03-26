//
//  GroupPrayEditView.swift
//  Moyang
//
//  Created by 정김기보 on 2021/12/01.
//

import SwiftUI

struct GroupPrayEditView: View {
    @ObservedObject var vm: GroupEditPrayVM
    
    var body: some View {
        ZStack {
            ScrollView(.vertical, showsIndicators: true) {
                if vm.isNameEdit {
                    ForEach(0 ..< vm.nameItem.prayItemList.count ) { i in
                        Text(vm.nameItem.prayItemList[i].date)
                            .font(.system(size: 16, weight: .regular, design: .default))
                            .foregroundColor(.nightSky1)
                            .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
                            .frame(maxWidth: .infinity, alignment: .leading)
                        TextEditor(text: $vm.nameItem.prayItemList[i].pray)
                            .font(.system(size: 16, weight: .regular, design: .default))
                            .frame(height: 35, alignment: .topLeading)
                            .foregroundColor(.nightSky1)
                            .padding(EdgeInsets(top: 0, leading: 20, bottom: 8, trailing: 20))
                    }
                } else {
                    ForEach(0 ..< vm.dateItem!.prayItemList.count ) { i in
                        Text(vm.dateItem.prayItemList[i].member)
                            .font(.system(size: 16, weight: .regular, design: .default))
                            .foregroundColor(.nightSky1)
                            .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
                            .frame(maxWidth: .infinity, alignment: .leading)
                        TextEditor(text: $vm.dateItem.prayItemList[i].pray)
                            .font(.system(size: 16, weight: .regular, design: .default))
                            .frame(height: 35, alignment: .topLeading)
                            .foregroundColor(.nightSky1)
                            .padding(EdgeInsets(top: 0, leading: 20, bottom: 8, trailing: 20))
                    }
                }
                
                Spacer()
            }
            
            VStack(spacing: 0) {
                Spacer()
                Button(action: {
                }) {
                    NavigationLink(destination: GroupPrayView(vm: GroupPrayVM(title: vm.prayTitle,
                                                                              pray: vm.prayContents))) {
                        Text("기도하기")
                    }
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
        .toolbar {
            Button("수정") {
                vm.editPray()
            }
        }
    }
}

struct CellMemberPrayEditView_Previews: PreviewProvider {
    static var previews: some View {
        GroupPrayEditView(vm: GroupEditPrayVM(groupRepo: GroupRepoImpl(service: FirestoreServiceImpl())))
    }
}
