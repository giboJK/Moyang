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
    
    @State private var myThought = "asdasdasdasdsadsad\nasdasdas"
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
                    Text(cellInfo.dateString)
                    Spacer()
                }
                HStack {
                    Text(cellInfo.talkingSubject)
                    Spacer()
                    Button(action: {
                        withAnimation {
                            showingMemo.toggle()
                        }
                    }, label: {
                        showingMemo ?
                        Image(systemName: "arrowtriangle.down.fill")
                            .accessibilityLabel("Close memo") :
                        Image(systemName: "arrowtriangle.up.fill")
                            .accessibilityLabel("Open memo")
                    })
                    .foregroundColor(Color.black)
                }
                if showingMemo {
                    ScrollView(.vertical, showsIndicators: false) {
                        ForEach(cellInfo.questionList, id: \.self) { question in
                            HStack {
                                Text(question)
                                    .frame(alignment: .topLeading)
                                    .font(.system(size: 16, weight: .regular, design: .default))
                                    .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
                                    .background(Color.white)
                                    .cornerRadius(10)
                                Spacer()
                            }
                            .padding(.bottom, 10)
                            TextEditor(text: $myThought)
                                .padding(.bottom, 20)
                                .frame(height: 200, alignment: .topLeading)
                            Divider()
                                .padding()
                        }
                    }
                    .frame(height: 400)
                    .transition(.asymmetric(insertion: .opacity, removal: .opacity))
                    .background(Color.white)
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
                                .font(.system(size: 16, weight: .regular, design: .default))
                                .padding(EdgeInsets(top: 5, leading: 20, bottom: 5, trailing: 20))
                                .background(Color.white)
                                .cornerRadius(10)
                            Spacer()
                        }
                        TextEditor(text: $myPray)
                            .padding(.bottom, 20)
                            .frame(height: 200, alignment: .topLeading)
                        Divider()
                            .padding()
                    }
                }
                Spacer()
            }
            .foregroundColor(Color.black)
            .navigationBarTitleDisplayMode(.inline)
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
