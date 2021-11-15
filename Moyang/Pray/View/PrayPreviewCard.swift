//
//  PrayPreviewCard.swift
//  Moyang
//
//  Created by 정김기보 on 2021/09/30.
//  Copyright © 2021 정김기보. All rights reserved.
//

import SwiftUI

struct PrayPreviewCard: View {
    @ObservedObject var viewModel: PrayPreviewVM

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
            return Text(error.localizedDescription).eraseToAnyView()
        case .loaded(let item):
            return VStack {
                HStack {
                    Text("나의 기도")
                        .font(.system(size: 20, weight: .bold, design: .default))
                        .padding(.top, 10)
                        .padding(.bottom, 5)
                    Spacer()
                }
                HStack {
                    Text(item.subject)
                        .font(.system(size: 16, weight: .regular, design: .default))
                        .frame(maxWidth: .infinity, alignment: .topLeading)
                    Spacer()
                }
                Spacer()
                Divider()
                HStack {
                    Text("다음 기도 시간")
                        .font(.system(size: 14, weight: .regular, design: .default))
                        .frame(maxWidth: .infinity, alignment: .topLeading)
                    Spacer()
                    Text("\(item.timeString)")
                        .font(.system(size: 14, weight: .regular, design: .default))
                }
                Spacer()
            }
            .modifier(MainCard())
            .eraseToAnyView()
        }
    }
}

struct PrayHistoryCard_Previews: PreviewProvider {
    static var previews: some View {
        PrayPreviewCard(viewModel: PrayPreviewVM(prayRepo: PrayRepoImpl()))
            .previewLayout(.fixed(width: 414, height: 150))
    }
}
