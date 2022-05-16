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
    var title: String
    var pray: String
    
    var body: some View {
        VStack(spacing: 0) {
            TextEditor(text: $vm.editingPray)
                .font(.system(size: 15, weight: .regular, design: .default))
                .frame(minHeight: 72, maxHeight: 440)
                .frame(maxWidth: .infinity, alignment: .topLeading)
                .foregroundColor(Color.nightSky1)
                .background(Color.sheep1)
            
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
                Button("저장") { }
            }
        }
        .onAppear {
            vm.setNameEditingPray(title: title)
        }
    }
}

struct PrayEditView_Previews: PreviewProvider {
    static var previews: some View {
        PrayEditView(vm: GroupEditPrayVM(groupRepo: GroupRepoImpl(service: FSServiceMock()),
                                         groupInfo: nil),
                     title: "",
                     pray: "")
    }
}
