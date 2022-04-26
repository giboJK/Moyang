//
//  GroupPrayView.swift
//  Moyang
//
//  Created by kibo on 2022/04/20.
//

import SwiftUI

struct GroupPrayView: View {
    var groupInfo: GroupInfo?
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 0) {
                GroupPrayList(vm: GroupPrayListVM(groupRepo: GroupRepoImpl(service: FSServiceImpl()),
                                                  groupInfo: groupInfo))
                .frame(height: 380)
                GroupPrayNotePreview()
                    .frame(height: 348)
                Spacer()
            }
        }
    }
}

struct GroupPrayView_Previews: PreviewProvider {
    static var previews: some View {
        GroupPrayView()
    }
}
