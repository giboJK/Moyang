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
                        .font(.system(size: 16, weight: .bold, design: .default))
                        .frame(alignment: .center)
                    Spacer()
                    Image(systemName: "arrow.forward")
                }
                .padding(.top, 10)
                
                HStack {
                    Text(preview.talkingSubject)
                        .font(.system(size: 14, weight: .regular, design: .default))
                        .frame(maxWidth: .infinity, alignment: .topLeading)
                }
                HStack(spacing: -8) {
                    ForEach(preview.previewMemberList) { member in
                        if let profileURL = member.profileURL {
                            AsyncImage(url: URL(string: profileURL))
                                .scaledToFill()
                                .frame(width: 40, height: 40, alignment: .center)
                                .cornerRadius(13)
                        } else {
                            Text(String(member.name.first ?? Character("")))
                                .frame(width: 40, height: 40, alignment: .center)
                                .background(Color(Asset.Colors.Bg.bgColorGray.color))
                                .cornerRadius(13)
                                .overlay(
                                        RoundedRectangle(cornerRadius: 13)
                                            .stroke(Color(Asset.Colors.Dessert.desertStone.color),
                                                    lineWidth: 1)
                                ).padding(.top, 1)
                        }
                    }
                    .padding(.bottom, 10)
                    Spacer()
                    if preview.memberList.count - preview.previewMemberList.count > 0 {
                        Text("+ \(preview.memberList.count - preview.previewMemberList.count)")
                    }
                }.frame(height: 60)
            }
            .modifier(MainCard())
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
