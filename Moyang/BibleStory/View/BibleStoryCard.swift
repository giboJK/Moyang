//
//  BibleStoryCard.swift
//  Moyang
//
//  Created by 정김기보 on 2021/09/29.
//  Copyright © 2021 정김기보. All rights reserved.
//

import SwiftUI

struct BibleStoryCard: View {
    @ObservedObject var viewModel: BibleStoryListVM
    
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
        case .loaded(let items):
            return VStack {
                HStack {
                    Text("성경 이야기")
                        .font(.system(size: 20, weight: .bold, design: .default))
                        .padding(.top, 10)
                    Spacer()
                }
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        ForEach(items) { item in
                            NavigationLink(destination: BibleStoryDetailView()) {
                                Image(uiImage: item.image)
                                    .resizable()
                                    .frame(width: 200, height: 120)
                                    .cornerRadius(10)
                            }
                        }
                    }
                }.frame(height: 120)
            }
            .padding(EdgeInsets(top: 0, leading: 20, bottom: 10, trailing: 20))
            .background(Color.white)
            .cornerRadius(20)
            .shadow(color: .gray.opacity(0.4), radius: 5, x: 2.0, y: 5)
            .eraseToAnyView()
        }
    }
}

struct BibleStoryCard_Previews: PreviewProvider {
    static var previews: some View {
        BibleStoryCard(viewModel: BibleStoryListVM(bibleStoryRepo: BibleStoryRepoImpl()))
            .previewLayout(.fixed(width: 414, height: 200))
    }
}
