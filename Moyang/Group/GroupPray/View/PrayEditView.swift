//
//  PrayEditView.swift
//  Moyang
//
//  Created by 정김기보 on 2022/05/15.
//

import SwiftUI

struct PrayEditView: View {
    @Environment(\.dismiss) private var dismiss
    
    @StateObject var vm: GroupEditPrayVM
    var prayId: String
    var title: String
    
    var body: some View {
        VStack(spacing: 0) {
            TextEditor(text: $vm.editingPray)
                .font(.system(size: 15, weight: .regular, design: .default))
                .frame(minHeight: 72, maxHeight: 440)
                .frame(maxWidth: .infinity, alignment: .topLeading)
                .foregroundColor(Color.nightSky1)
                .background(Color.sheep1)
                .padding(.top, 12)
            
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .background(Color.sheep2)
        .toolbar {
            ToolbarItem(placement: .navigation) {
                Button("취소") {
                    dismiss()
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("저장") {
                    vm.editNameItemPray(id: prayId)
                }
            }
        }
        .onAppear {
            vm.setNameEditingPray(id: prayId)
        }
    }
}

struct PrayEditView_Previews: PreviewProvider {
    static var previews: some View {
        PrayEditView(vm: GroupEditPrayVM(groupRepo: GroupRepoImpl(service: FSServiceMock()),
                                         groupInfo: nil),
                     prayId: "",
                     title: "")
    }
}
