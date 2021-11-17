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
                ScrollView(.horizontal) {
                    HStack(spacing: 10) {
                        ForEach(preview.memberList) { member in
                            if let profileURL = member.profileURL {
                                
                            } else {
                                Text(member.name)
                            }
                        }
                    }
                    .padding(.bottom, 10)
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
