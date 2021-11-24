//
//  CellMeetingView.swift
//  Moyang
//
//  Created by 정김기보 on 2021/10/19.
//  Copyright © 2021 정김기보. All rights reserved.
//

import SwiftUI

struct CellMeetingView: View {
    @ObservedObject var viewModel: CellMeetingVM
    
    @State private var showingMemo = true
    
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
        case .loaded(let cellInfo):
            return VStack {
                HStack {
                    Text("셀 모임 질문")
                        .font(.system(size: 17, weight: .bold))
                    Spacer()
                    Image(systemName: "arrow.forward")
                }
                .padding(.bottom, 1)
                HStack {
                    Text(cellInfo.talkingSubject)
                        .font(.system(size: 15, weight: .regular))
                    Spacer()
                    Button(action: {
                        withAnimation {
                            showingMemo.toggle()
                        }
                    }, label: {
                        showingMemo ?
                        Image(systemName: "arrowtriangle.down.fill") :
                        Image(systemName: "arrowtriangle.up.fill")
                    })
                    .foregroundColor(Color.black)
                }
                HStack {
                    Text(cellInfo.dateString)
                        .font(.system(size: 13, weight: .regular))
                    Spacer()
                }
                if showingMemo {
                    ScrollView(.vertical, showsIndicators: true) {
                        ForEach(0 ..< cellInfo.questionList.count) { i in
                            let question = cellInfo.questionList[i]
                            HStack {
                                Text("- " + question)
                                    .frame(alignment: .topLeading)
                                    .font(.system(size: 15, weight: .regular, design: .default))
                                Spacer()
                            }
                            .padding(EdgeInsets(top: 0, leading: 4, bottom: -10, trailing: 0))
                            TextEditor(text: $viewModel.answerList[i])
                                .padding(.bottom, 10)
                                .font(.system(size: 14, weight: .regular, design: .default))
                                .frame(height: 75, alignment: .topLeading)
                                .colorMultiply(Color(Asset.Colors.Bg.bgColorGray.color))
                        }
                    }
                    .transition(.asymmetric(insertion: .opacity, removal: .opacity))
                    .frame(height: 280)
                }
                Divider()
                    .padding(.top, 5)
                NavigationLink(destination: CellPrayListView(viewModel: CellPrayListVM(coordinator: CellCoordinator()))) {
                    HStack {
                        Text("지난기도")
                            .font(.system(size: 17, weight: .bold))
                        Spacer()
                        Image(systemName: "arrow.forward")
                    }

                }
                .padding(.top, 5)
                HStack {
                    Text("새 기도제목")
                        .font(.system(size: 17, weight: .bold))
                    Spacer()
                    Image(systemName: "plus")
                }
                .padding(.top, 5)
                Spacer()
            }
            .foregroundColor(Color.black)
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle(cellInfo.cellName)
            .padding(EdgeInsets(top: 14, leading: 20, bottom: 0, trailing: 20))
            .background(Color(Asset.Colors.Bg.bgColorGray.color))
            .eraseToAnyView()
        }
    }
}

struct CellMeetingView_Previews: PreviewProvider {
    static var previews: some View {
        CellMeetingView(viewModel: CellMeetingVM(cellRepo: CellRepoImpl()))
    }
}
