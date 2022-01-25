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
        VStack {
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
        }
        .frame(maxWidth: .infinity)
        .background(Color.sheep1)
        .navigationBarTitle("기도 수정")
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
