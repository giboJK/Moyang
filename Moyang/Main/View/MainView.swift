//
//  MainView.swift
//  Moyang
//
//  Created by 정김기보 on 2021/10/23.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        NavigationView {
            ZStack {
                Color(UIColor.bgColor).ignoresSafeArea()
                VStack(spacing: 0) {
                    HStack {
                        Text("Daily Bread")
                            .font(.system(size: 24, weight: .black, design: .default))
                            .padding(EdgeInsets(top: 0, leading: 20, bottom: 10, trailing: 0))
                        Spacer()
                    }
                    DailySummaryView(viewModel: DailySummaryVM())
                        .padding(EdgeInsets(top: 10, leading: 0, bottom: 15, trailing: 0))
                    Divider()
                        .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
                    MainCategoryList()
                        .padding(EdgeInsets(top: 15, leading: 0, bottom: 0, trailing: 0))
                }
                .padding(.top, 30)
                .background(Color(UIColor.bgColor))
            }
            .navigationBarHidden(true)
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
