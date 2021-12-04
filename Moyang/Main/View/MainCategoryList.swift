//
//  MainCategoryList.swift
//  Moyang
//
//  Created by 정김기보 on 2021/09/26.
//  Copyright © 2021 정김기보. All rights reserved.
//

import SwiftUI

struct MainCategoryList: View {
    private let prayHistoryVM = PrayPreviewVM(prayRepo: PrayRepoImpl())
    private let prayListVM = PrayListViewModel(prayRepo: PrayRepoImpl())
    private let cellRepo = CellRepoImpl()
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 20) {
                NavigationLink(destination: CellMeetingView(viewModel: CellMeetingVM(cellRepo: cellRepo))) {
                    CellPreviewCard(viewModel: CellPreviewVM(cellRepo: cellRepo))
                }
//                QTPreviewCard()
//                NavigationLink(destination: PrayListView(viewModel: prayListVM)) {
//                    PrayPreviewCard(viewModel: prayHistoryVM)
//                }
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
