//
//  DailyView.swift
//  Moyang
//
//  Created by kibo on 2022/01/14.
//

import SwiftUI

struct DailyView: View {
    var body: some View {
        ZStack {
            Color.sheep1.ignoresSafeArea()
            VStack(spacing: 0) {
                HStack {
                    Text("Daily Bread")
                        .font(.system(size: 24, weight: .black, design: .default))
                        .padding(EdgeInsets(top: 0, leading: 20, bottom: 10, trailing: 0))
                        .foregroundColor(.nightSky1)
                    Spacer()
                }
                DailySummaryView(vm: DailySummaryVM())
                    .padding(EdgeInsets(top: 10, leading: 0, bottom: 15, trailing: 0))
                Divider()
                    .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
                MainCategoryList()
                    .padding(EdgeInsets(top: 15, leading: 0, bottom: 0, trailing: 0))
            }
            .padding(.top, 30)
            .background(Color.sheep1)
        }
    }
}

struct DailyView_Previews: PreviewProvider {
    static var previews: some View {
        DailyView()
    }
}
