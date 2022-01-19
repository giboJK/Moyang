//
//  DailySummaryView.swift
//  Moyang
//
//  Created by kibo on 2021/10/07.
//  Copyright © 2021 정김기보. All rights reserved.
//

import SwiftUI

struct DailySummaryView: View {
    @ObservedObject var vm: DailySummaryVM
    
    var body: some View {
        VStack {
            HStack(spacing: 0) {
                ForEach(vm.items) { item in
                    VStack {
                        Text(item.date.toString("d"))
                        Text(item.date.weekDayString())
                            .frame(maxWidth: .infinity)
                            .foregroundColor(item.id == 0 ? Color.red : Color.black)
                        Text("chk")
                            .frame(maxWidth: .infinity)
                            .background(Color.desertStone2)
                    }
                }
            }
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color(Asset.Colors.Dessert.lightSand.color), lineWidth: 1)
            )
        }
        .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
    }
}

struct DailySummaryView_Previews: PreviewProvider {
    static var previews: some View {
        DailySummaryView(vm: DailySummaryVM())
            .previewLayout(.fixed(width: 414, height: 100))
    }
}
