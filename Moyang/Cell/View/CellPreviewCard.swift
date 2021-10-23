//
//  CellPreviewCard.swift
//  Moyang
//
//  Created by 정김기보 on 2021/10/09.
//  Copyright © 2021 정김기보. All rights reserved.
//

import SwiftUI

struct CellPreviewCard: View {
    @ObservedObject var viewModel: CellPreviewVM
    
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
            return Text("Loading...").eraseToAnyView()
        case .error(let error):
            Log.e(error)
            return Text(error.localizedDescription).eraseToAnyView()
        case .loaded(let preview):
            return VStack {
                HStack {
                    Text(preview.cellName)
                        .font(.system(size: 20, weight: .bold, design: .default))
                        .frame(width: 200, height: 40, alignment: .leading)
                    Spacer()
                }
                HStack {
                    Text("이번주 주제:")
                        .font(.system(size: 16, weight: .regular, design: .default))
                    Text(preview.talkingSubject)
                        .font(.system(size: 16, weight: .regular, design: .default))
                        .padding(.leading, 10)
                        .frame(maxWidth: .infinity, alignment: .topLeading)
                }
                Divider()
                HStack {
                    Text("셀 기도제목")
                        .font(.system(size: 16, weight: .regular, design: .default))
                        .frame(maxWidth: .infinity, minHeight: 20, alignment: .leading)
                    Spacer()
                }
                ScrollView(.horizontal) {
                    HStack(spacing: 10) {
                        ForEach(preview.prayList) { pray in
                            Text(pray.praySubject)
                                .frame(width: 80, height: 60, alignment: .center)
                                .font(.system(size: 14, weight: .regular, design: .default))
                                .background(Color(Asset.bgColorGray.color))
                                .cornerRadius(10)
                        }
                    }
                    .padding(.bottom, 10)
                }.frame(height: 60)
            }
            .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
            .foregroundColor(Color.black)
            .background(Color.white)
            .cornerRadius(20)
            .shadow(color: .gray.opacity(0.4), radius: 5, x: 2.0, y: 5)
            .eraseToAnyView()
        }
    }
}

struct CellPreviewCard_Previews: PreviewProvider {
    static var previews: some View {
        CellPreviewCard(viewModel: CellPreviewVM(cellRepo: CellRepoImpl()))
            .previewLayout(.fixed(width: 414, height: 200))
    }
}
