//
//  MainCategoryList.swift
//  Moyang
//
//  Created by 정김기보 on 2021/09/26.
//  Copyright © 2021 정김기보. All rights reserved.
//

import SwiftUI

struct MainCategoryList: View {
    @ObservedObject var prayListVM = PrayListVM(prayRepo: PrayRepoImpl())
    @ObservedObject var vm = MainCategoryVM(repo: SummaryRepoImpl())
    private let cellRepo = CellRepoImpl()
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 20) {
                NavigationLink(destination: CellMeetingView(viewModel: CellMeetingVM(cellRepo: cellRepo))) {
                    CellPreviewCard(vm: CellPreviewVM(cellRepo: cellRepo))
                }
                NavigationLink(destination: PrayListView(viewModel: prayListVM)) {
                    if let prayCardVM = vm.prayCardVM {
                        PrayPreviewCard(vm: prayCardVM)
                    }
                }
            }
        }
        .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
        .background(Color(UIColor.bgColor))
        Spacer()
        
        Button(action: addPray) {
            Text("Add New Card")
                .foregroundColor(.blue)
        }.onAppear {
            vm.fetchSummary()
        }
    }
    
    private func addPray() {
        let praySubject = PraySubject(id: "asdb12313312", subject: "ddkdkkd", timeString: Date().toString())
        prayListVM.add(praySubject)
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
