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
                Color(Asset.bgColor.color).ignoresSafeArea()
                VStack(spacing: 0) {
                    HStack {
                        Text("Moyang Everyday")
                            .font(.system(size: 24, weight: .black, design: .default))
                            .padding(EdgeInsets(top: 0, leading: 20, bottom: 10, trailing: 0))
                        Spacer()
                    }
                    DailySummaryView(viewModel: DailySummaryVM())
                        .padding(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0))
                    Divider()
                    HStack {
                        Text("Christian Life")
                            .font(.system(size: 24, weight: .black, design: .default))
                            .padding(.leading, 20)
                        Spacer()
                    }
                    .padding(EdgeInsets(top: 25, leading: 0, bottom: 10, trailing: 0))
                    .background(Color(Asset.bgColor.color))
                    MainCategoryList()
                }
                .padding(.top, 30)
                .background(Color(Asset.bgColor.color))
            }
            .navigationBarHidden(true)
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
