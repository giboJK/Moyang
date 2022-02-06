//
//  CommunityCardList.swift
//  Moyang
//
//  Created by 정김기보 on 2021/09/26.
//  Copyright © 2021 정김기보. All rights reserved.
//

import SwiftUI

struct CommunityCardList: View {
    @ObservedObject var vm: CommunityCardListVM
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 20) {
                NavigationLink(destination: GroupView()) {
                    CommunityGroupCardView(vm: vm.communityGroupCardVM)
                }
                NavigationLink(destination: PrayView()) {
                    CommunityPrayCardView()
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

struct CommunityCardList_Previews: PreviewProvider {
    static var previews: some View {
        CommunityCardList(vm: CommunityCardListVMMock())
    }
}
