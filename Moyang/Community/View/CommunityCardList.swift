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
            VStack(spacing: 24) {
                if vm.hasGroup {
                    NavigationLink(destination: GroupView()) {
                        CommunityGroupCardView(vm: vm.communityGroupCardVM)
                            .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
                    }
                } else {
                    CommunityGroupCardView(vm: vm.communityGroupCardVM)
                        .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
                }
                NavigationLink(destination: PrayView()) {
                    CommunityPrayCardView(vm: vm.communityPrayCardVM)
                }
            }
        }.onAppear {
            vm.fetchDailyPreview()
        }
        .background(Color.sheep2)
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
        NavigationView {
            CommunityCardList(vm: CommunityCardListVMMock())
        }
    }
}
