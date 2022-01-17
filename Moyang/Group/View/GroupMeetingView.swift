//
//  GroupMeetingView.swift
//  Moyang
//
//  Created by 정김기보 on 2021/10/19.
//  Copyright © 2021 정김기보. All rights reserved.
//

import SwiftUI

struct GroupMeetingView: View {
    @ObservedObject var vm: GroupMeetingVM
    
    @State private var showingMemo = true
    
    var body: some View {
        VStack {
            HStack {
                Text("셀 모임 질문")
                    .font(.system(size: 19, weight: .bold))
                Spacer()
                Image(systemName: "arrow.forward")
            }
            .padding(.bottom, 1)
            HStack {
                Text(vm.groupInfoItem.talkingSubject)
                    .font(.system(size: 16, weight: .regular))
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
                Text(vm.groupInfoItem.meetingDate)
                    .font(.system(size: 13, weight: .regular))
                Spacer()
            }
            if showingMemo {
                ScrollView(.vertical, showsIndicators: true) {
                    ForEach(0 ..< vm.groupInfoItem.questionList.count) { i in
                        let question = vm.groupInfoItem.questionList[i]
                        HStack {
                            Text("- " + question)
                                .frame(alignment: .topLeading)
                                .font(.system(size: 15, weight: .regular, design: .default))
                            Spacer()
                        }
                        .padding(EdgeInsets(top: 0, leading: 4, bottom: -10, trailing: 0))
                        TextEditor(text: $vm.answerList[i])
                            .padding(.bottom, 10)
                            .font(.system(size: 14, weight: .regular, design: .default))
                            .frame(height: 75, alignment: .topLeading)
                            .colorMultiply(Color(UIColor.sheep))
                    }
                }
                .transition(.asymmetric(insertion: .opacity, removal: .opacity))
                .frame(height: 280)
            }
            Divider()
                .padding(.top, 5)
            NavigationLink(destination: CellPrayListView(viewModel: CellPrayListVM(groupRepo: GroupRepoImpl(service: FirestoreServiceImpl())))) {
                HStack {
                    Text("지난기도")
                        .font(.system(size: 17, weight: .bold))
                    Spacer()
                    Image(systemName: "arrow.forward")
                }
                
            }
            .padding(.top, 5)
            NavigationLink(destination: NewCellPrayView(viewModel: NewCellPrayVM())) {
                HStack {
                    Text("새 기도제목")
                        .font(.system(size: 17, weight: .bold))
                    Spacer()
                    Image(systemName: "plus")
                }
            }
            .padding(.top, 5)
            Spacer()
        }
        .foregroundColor(Color.black)
        .navigationTitle(vm.groupInfoItem.groupName)
        .padding(EdgeInsets(top: 14, leading: 20, bottom: 0, trailing: 20))
        .background(Color(UIColor.sheep))
        .eraseToAnyView()
    }
}

struct CellMeetingView_Previews: PreviewProvider {
    static var previews: some View {
        GroupMeetingView(vm: GroupMeetingVM(repo: GroupRepoImpl(service: FirestoreServiceImpl())))
    }
}
