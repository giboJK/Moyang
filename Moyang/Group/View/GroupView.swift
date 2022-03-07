//
//  GroupView.swift
//  Moyang
//
//  Created by kibo on 2022/02/05.
//

import SwiftUI
import AlertToast

struct GroupView: View {
    @State var tabIndex = 0
    @StateObject var vm = GroupVM()
    
    var body: some View {
        VStack(spacing: 0) {
            TopTabBar(tabIndex: $tabIndex)
            if tabIndex == 0 {
                GroupSharingView(vm: GroupSharingVM(repo: GroupRepoImpl(service: FirestoreServiceImpl())))
            }
            else {
                GroupPrayListView(vm: GroupPrayListVM(groupRepo: GroupRepoImpl(service: FirestoreServiceImpl())))
                
            }
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .background(Color.sheep1)
        .toast(isPresenting: $vm.newPrayAddSuccess) {
            return AlertToast(type: .complete(.sheep3), title: "기도 추가 완료 😀")
        }
    }
}

struct GroupView_Previews: PreviewProvider {
    static var previews: some View {
        GroupView()
    }
}
