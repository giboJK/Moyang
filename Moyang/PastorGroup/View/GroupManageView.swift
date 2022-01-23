//
//  GroupManageView.swift
//  Moyang
//
//  Created by 정김기보 on 2022/01/23.
//

import SwiftUI

struct GroupManageView: View {
    var body: some View {
        VStack(spacing: 20) {
            Text("그룹 관리")
            Text("공동체 기도 목록")
        }
        .padding(.top, 30)
        .background(Color.sheep1)
    }
}

struct GroupManageView_Previews: PreviewProvider {
    static var previews: some View {
        GroupManageView()
    }
}
