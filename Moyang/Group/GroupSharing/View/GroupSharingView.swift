//
//  GroupSharingView.swift
//  Moyang
//
//  Created by 정김기보 on 2021/10/19.
//  Copyright © 2021 정김기보. All rights reserved.
//

import SwiftUI
import AlertToast

struct GroupSharingView: View {
    @ObservedObject var vm: GroupSharingVM
    
    @State private var showingMemo = true
    init(vm: GroupSharingVM) {
        self.vm = vm
        UITextView.appearance().backgroundColor = .clear
    }
    
    var body: some View {
        VStack {
            HStack {
                Text("셀 모임 질문")
                    .font(.system(size: 16, weight: .bold))
                Spacer()
                Image(systemName: "arrow.forward")
            }
            .padding(.bottom, 1)
            HStack {
                Text(vm.talkingSubject)
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
                Text(vm.meetingDate)
                    .font(.system(size: 13, weight: .regular))
                Spacer()
            }
            if showingMemo {
                ScrollView(.vertical, showsIndicators: true) {
                    ForEach(0 ..< vm.groupQuestionList.count) { i in
                        let item = vm.groupQuestionList[i]
                        HStack {
                            Text("- " + item.question.sentence)
                                .frame(alignment: .topLeading)
                                .font(.system(size: 15, weight: .regular, design: .default))
                            Spacer()
                        }
                        .padding(EdgeInsets(top: 0, leading: 4, bottom: -10, trailing: 0))
                        TextEditor(text: $vm.answerList[i])
                            .font(.system(size: 14, weight: .regular, design: .default))
                            .frame(height: 75, alignment: .topLeading)
                            .foregroundColor(Color.nightSky1)
                            .background(Color.sheep1)
                        Spacer(minLength: 10)
                    }
                }
                .transition(.asymmetric(insertion: .opacity, removal: .opacity))
                .frame(height: 280)
            }
            Divider()
            Spacer()
        }
        .foregroundColor(Color.black)
        .navigationTitle(vm.groupName)
        .padding(EdgeInsets(top: 14, leading: 20, bottom: 0, trailing: 20))
        .background(Color.sheep1)
    }
}

struct GroupMeetingView_Previews: PreviewProvider {
    static var previews: some View {
        GroupSharingView(vm: GroupSharingVM(repo: GroupRepoImpl(service: FirestoreServiceImpl())))
    }
}
