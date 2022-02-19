//
//  GroupManageListView.swift
//  Moyang
//
//  Created by 정김기보 on 2022/02/18.
//

import SwiftUI

struct GroupManageListView: View {
    @ObservedObject var vm: GroupManageListVM
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct GroupManageListView_Previews: PreviewProvider {
    static var previews: some View {
        GroupManageListView(vm: GroupManageListVMMock())
    }
}
