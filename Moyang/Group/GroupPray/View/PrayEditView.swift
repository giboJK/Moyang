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
    @FocusState var focus: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
                Spacer()
            }
            Spacer()
        }
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
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button("완료") { focus = false }
            }
        }
    }
}

struct PrayEditView_Previews: PreviewProvider {
    static var previews: some View {
        PrayEditView(vm: GroupEditPrayVM(groupRepo: GroupRepoImpl(service: FSServiceMock()),
                                         groupInfo: nil))
    }
}
