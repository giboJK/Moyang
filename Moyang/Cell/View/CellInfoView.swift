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
    
    private let questionList = ["내가 공경할 수 있는 사람은 어떤 유형의 사람인가요?",
                                "내가 공경하지 않은 사람은 어떤 유형의 사람인가요?",
                                "성경에서 공경하라는 무슨 뜻인가요?"]
    @State private var myThought = "asdasdasdasdsadsad\nasdasdas"
    @State private var showingMemo = true
    
    var body: some View {
        VStack {
            HStack {
                Text("이번주 주제")
                Spacer()
            }
            HStack {
                Text("네 부모를 공경하라")
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
            Divider()
            if showingMemo {
                ScrollView(.vertical, showsIndicators: false) {
                    ForEach(questionList, id: \.self) { question in
                        HStack(spacing: 10) {
                            Text(question)
                                .frame(alignment: .topLeading)
                                .font(.system(size: 16, weight: .regular, design: .default))
                                .background(Color(Asset.bgColorGray.color))
                                .cornerRadius(10)
                            Spacer()
                        }
                        .padding(.bottom, 10)
                        TextEditor(text: $myThought)
                            .padding(.bottom, 20)
                            .frame(height: 200, alignment: .topLeading)
                    }
                }
                .frame(height: 500)
                .transition(.asymmetric(insertion: .opacity, removal: .opacity))
                .background(Color.white)
            }
            HStack {
                Spacer()
                NavigationLink(destination: CellSubjectHistoryView()) {
                    Text("모임 주제 모두 보기")
                }
            }
            Divider()
            
            Spacer()
        }
//        .navigationTitle("Navigation")
        .navigationBarTitleDisplayMode(.inline)
        .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
        .background(Color(Asset.bgColorGray.color))
    }
}

struct CellInfoView_Previews: PreviewProvider {
    static var previews: some View {
        CellInfoView(viewModel: CellInfoVM(cellRepo: CellRepoImpl()))
    }
}
