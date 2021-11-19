//
//  DailySummaryView.swift
//  Moyang
//
//  Created by kibo on 2021/10/07.
//  Copyright © 2021 정김기보. All rights reserved.
//

import SwiftUI

struct DailySummaryView: View {
    @ObservedObject var viewModel: DailySummaryVM
    
    var body: some View {
        content
            .onAppear {
                self.viewModel.send(event: .onAppear)
            }
    }
    
    private var content: some View {
        switch viewModel.state {
        case .idle:
            return Color.clear.eraseToAnyView()
        case .loading:
            return Color.clear.eraseToAnyView()
        case .error(let error):
            Log.e(error)
            return Color.clear.eraseToAnyView()
        case .loaded(let items):
            return VStack {
                HStack(spacing: 0) {
                    ForEach(items) { item in
                        VStack {
                            Text(item.date.toString("d"))
                            Text(item.date.weekDayString())
                                .frame(maxWidth: .infinity)
                                .foregroundColor(item.id == 0 ? Color.red : Color.black)
                            Text("chk")
                                .frame(maxWidth: .infinity)
                                .background(Color(Asset.Colors.Dessert.desertLightStone.color))
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
            .eraseToAnyView()
        }
    }
}

struct DailySummaryView_Previews: PreviewProvider {
    static var previews: some View {
        DailySummaryView(viewModel: DailySummaryVM())
            .previewLayout(.fixed(width: 414, height: 100))
    }
}
