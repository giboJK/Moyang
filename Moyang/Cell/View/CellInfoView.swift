//
//  CellInfoView.swift
//  Moyang
//
//  Created by 정김기보 on 2021/10/19.
//  Copyright © 2021 정김기보. All rights reserved.
//

import SwiftUI

struct CellInfoView: View {
    @ObservedObject var viewModel: CellInfoVM
    
    @State private var myThought = "asdasdasdasdsadsad\nasaad\nasaad\nasasdadsadsda\nasasdadsadsdadasdas"
    @State private var myPray = "asdasdas"
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
                        .font(.system(size: 16, weight: .bold))
                    Spacer()
                    Image(systemName: "arrow.forward")
                }
                .padding(.bottom, 1)
                HStack {
                    Text(cellInfo.talkingSubject)
                        .font(.system(size: 14, weight: .regular))
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
                        .font(.system(size: 12, weight: .regular))
                    Spacer()
                }
                if showingMemo {
                    ScrollView(.vertical, showsIndicators: false) {
                        ForEach(cellInfo.questionList, id: \.self) { question in
                            HStack {
                                Text(question)
                                    .frame(alignment: .topLeading)
                                    .font(.system(size: 14, weight: .regular, design: .default))
                                Spacer()
                            }
                            .padding(EdgeInsets(top: 0, leading: 4, bottom: -10, trailing: 0))
                            TextEditor(text: $myThought)
                                .padding(.bottom, 10)
                                .font(.system(size: 13, weight: .regular, design: .default))
                                .frame(height: 70, alignment: .topLeading)
                                .colorMultiply(Color(Asset.Colors.Bg.bgColorGray.color))
                        }
                    }
                    .transition(.asymmetric(insertion: .opacity, removal: .opacity))
                }
                HStack {
                    Spacer()
                    NavigationLink(destination: CellSubjectHistoryView()) {
                        Text("모임 주제 모두 보기")
                        Image(systemName: "book.fill")
                    }
                }
                Divider()
                HStack {
                    Text("셀 기도제목")
                    Spacer()
                }
                .padding(.top, 14)
                ScrollView(.vertical, showsIndicators: false) {
                    ForEach(cellInfo.prayList) { member in
                        HStack {
                            Text(member.praySubject)
                                .frame(alignment: .topLeading)
                                .font(.system(size: 14, weight: .regular, design: .default))
                                .padding(EdgeInsets(top: 5, leading: 20, bottom: 5, trailing: 20))
                                .background(Color.white)
                                .cornerRadius(10)
                            Spacer()
                        }
                        TextEditor(text: $myPray)
                            .padding(.bottom, 20)
                            .frame(height: 100, alignment: .topLeading)
                        Divider()
                            .padding()
                    }
                }
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

struct CellInfoView_Previews: PreviewProvider {
    static var previews: some View {
        CellInfoView(viewModel: CellInfoVM(cellRepo: CellRepoImpl()))
    }
}
