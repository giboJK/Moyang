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
                NavigationLink(destination: GroupMeetingView(vm: GroupMeetingVM(repo: groupRepo))) {
                    if let groupCardVM = vm.groupCardVM {
                        GroupPreviewCard(vm: groupCardVM)
                    }
                }
                NavigationLink(destination: PrayListView(vm: PrayListVM(prayRepo: prayRepo))) {
                    if let prayCardVM = vm.prayCardVM {
                        PrayPreviewCard(vm: prayCardVM)
                    }
                }
            }
        }.onAppear {
            vm.fetchDailyPreview()
        }
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
