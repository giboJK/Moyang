//
//  MainCategoryList.swift
//  Moyang
//
//  Created by 정김기보 on 2021/09/26.
//  Copyright © 2021 정김기보. All rights reserved.
//

import SwiftUI

struct MainCategoryList: View {
    @ObservedObject var vm = MainCategoryVM(repo: DailyRepoImpl())
    private let groupRepo = GroupRepoImpl(service: FirestoreServiceImpl())
    private let prayRepo = PrayRepoImpl(service: FirestoreServiceImpl())
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 20) {
                NavigationLink(destination: CellMeetingView(vm: GroupMeetingVM(repo: groupRepo))) {
                    if let cellCardVM = vm.cellCardVM {
                        CellPreviewCard(vm: cellCardVM)
                    }
                }
                NavigationLink(destination: PrayListView(vm: PrayListVM(prayRepo: prayRepo))) {
                    if let prayCardVM = vm.prayCardVM {
                        PrayPreviewCard(vm: prayCardVM)
                    }
                }
            }
        }
        .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
        .background(Color(UIColor.bgColor))
    }
}

enum MainCategory: String {
    case story
    case question
    case pray
    case osundosun
}

struct MainCategoryList_Previews: PreviewProvider {
    static var previews: some View {
        MainCategoryList()
    }
}
