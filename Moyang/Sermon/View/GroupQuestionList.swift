//
//  GroupQuestionList.swift
//  Moyang
//
//  Created by 정김기보 on 2022/02/07.
//

import SwiftUI

struct GroupQuestionList: View {
    @ObservedObject var vm: GroupQuestionListVM
    @State var newQuestion = false
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("질문 목록")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.system(size: 16, weight: .semibold, design: .default))
                    .foregroundColor(.nightSky1)
                    .padding(.leading, 24)
                Spacer()
                Button(action: {
                    vm.addQuestion()
                    newQuestion.toggle()
                }) {
                    Image(systemName: "plus.app.fill")
                        .foregroundColor(.nightSky1)
                }
                .frame(width: 24, height: 24)
                .padding(.trailing, 16)
                
                NavigationLink(destination: NewGroupQuestionView(vm: vm,
                                                                 index: vm.groupQuestionList.count - 1,
                                                                 isEdit: false),
                               isActive: $newQuestion) {}
            }
            .padding(.bottom, 4)
            
            ForEach(vm.groupQuestionList.indices, id: \.self) { i in
                let item = vm.groupQuestionList[i]
                NavigationLink(destination: NewGroupQuestionView(vm: vm, index: i, isEdit: true)) {
                    VStack(spacing: 0) {
                        HStack(spacing: 0) {
                            Text("질문 \(i + 1)")
                                .frame(maxHeight: .infinity, alignment: .top)
                                .font(.system(size: 15, weight: .regular, design: .default))
                                .foregroundColor(.nightSky1)
                            
                            Text(vm.groupQuestionList[i].question.sentence)
                                .frame(maxHeight: .infinity, alignment: .topLeading)
                                .font(.system(size: 15, weight: .regular, design: .default))
                                .foregroundColor(.nightSky1)
                                .padding(.leading, 8)
                            Spacer()
                        }
                        .padding(EdgeInsets(top: 12, leading: 8, bottom: 4, trailing: 8))
                        HStack(spacing: 0) {
                            Text("답변")
                                .frame(maxHeight: .infinity, alignment: .top)
                                .font(.system(size: 15, weight: .regular, design: .default))
                                .foregroundColor(.nightSky1)
                            
                            Text(vm.groupQuestionList[i].question.answer)
                                .frame(maxHeight: .infinity, alignment: .topLeading)
                                .font(.system(size: 15, weight: .regular, design: .default))
                                .foregroundColor(.nightSky1)
                                .padding(.leading, 8)
                            Spacer()
                        }
                        .padding(EdgeInsets(top: 0, leading: 8, bottom: 4, trailing: 8))
                        
                        Text(item.subquestionList.isEmpty ? "하위질문 없음" : "하위질문 \(item.subquestionList.count)개")
                            .foregroundColor(item.subquestionList.isEmpty ? .sheep4 : .nightSky1)
                            .font(.system(size: 14, weight: .regular, design: .default))
                            .frame(maxWidth: .infinity, alignment: .trailing)
                            .padding(EdgeInsets(top: 0, leading: 0, bottom: 12, trailing: 8))
                    }
                    .background(Color.sheep1)
                    .cornerRadius(12)
                    .padding(EdgeInsets(top: 4, leading: 16, bottom: 8, trailing: 16))
                }
            }
        }
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button("완료") {
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }
            }
        }
        .onAppear {
            UITextView.appearance().backgroundColor = .sheep1
        }
    }
}

struct GroupQuestionList_Previews: PreviewProvider {
    static var previews: some View {
        GroupQuestionList(vm: GroupQuestionListVMMock())
    }
}
