//
//  GroupDateSortedPrayEditView.swift
//  Moyang
//
//  Created by 정김기보 on 2022/04/19.
//

import SwiftUI

struct GroupDateSortedPrayEditView: View {
    @StateObject var vm: GroupEditPrayVM
    @FocusState private var focus: Bool
    @State private var isPraying: Bool = false
    
    var body: some View {
        ZStack {
            ScrollView(.vertical, showsIndicators: true) {
                VStack(spacing: 0) {
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
                            .frame(maxHeight: 240, alignment: .topLeading)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.sheep4, lineWidth: 0.5)
                            )
                            .foregroundColor(.nightSky1)
                            .padding(EdgeInsets(top: 8, leading: 20, bottom: 8, trailing: 20))
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
                                               height: 48))
                .padding(.bottom, 10)
            }
        }
        .frame(maxWidth: .infinity)
        .background(Color.sheep1)
        .navigationBarTitle(vm.dateItem.date)
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

struct GroupDateSortedPrayEditView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            GroupDateSortedPrayEditView(vm: GroupEditPrayVMMock())
        }
    }
}
