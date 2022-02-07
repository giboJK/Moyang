//
//  GroupQuestionList.swift
//  Moyang
//
//  Created by 정김기보 on 2022/02/07.
//

import SwiftUI

struct GroupQuestionList: View {
    @ObservedObject var vm: GroupQuestionListVM
    
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
                }, label: {
                    Image(systemName: "plus.app.fill")
                        .foregroundColor(.nightSky1)
                })
                    .frame(width: 24, height: 24)
                    .padding(.trailing, 16)
            }
            .padding(.bottom, 4)
            ForEach(0 ..< vm.groupQuestionList.count, id: \.self) { i in
                var item = vm.groupQuestionList[i]
                VStack(spacing: 0) {
                    HStack(spacing: 0) {
                        Text("질문")
                            .frame(maxHeight: .infinity, alignment: .top)
                            .font(.system(size: 15, weight: .regular, design: .default))
                            .foregroundColor(.nightSky1)
                        
                        TextEditor(text: $vm.groupQuestionList[i].question.sentence)
                            .font(.system(size: 15, weight: .regular, design: .default))
                            .frame(height: 55, alignment: .topLeading)
                            .foregroundColor(vm.groupQuestionList[i].question.sentence == "입력하세요" ? .gray : .nightSky1)
                            .onTapGesture {
                                if vm.groupQuestionList[i].question.sentence == "입력하세요" {
                                    vm.groupQuestionList[i].question.sentence = ""
                                }
                            }
                            .padding(EdgeInsets(top: 0, leading: 12, bottom: 0, trailing: 12))
                    }
                    .padding(EdgeInsets(top: 12, leading: 8, bottom: 4, trailing: 8))
                    HStack(spacing: 0) {
                        Text("답변")
                            .frame(maxHeight: .infinity, alignment: .top)
                            .font(.system(size: 15, weight: .regular, design: .default))
                            .foregroundColor(.nightSky1)
                        Text(item.question.answer)
                            .frame(maxWidth: .infinity, alignment: .topLeading)
                            .font(.system(size: 15, weight: .regular, design: .default))
                            .padding(.leading, 12)
                    }
                    .padding(EdgeInsets(top: 0, leading: 8, bottom: 4, trailing: 8))
                    HStack(spacing: 0) {
                        Spacer()
                        Button(action: {
                            vm.addSubQuestion(index: i)
                        }, label: {
                            Text("서브질문 추가")
                                .font(.system(size: 15, weight: .regular, design: .default))
                                .foregroundColor(.nightSky1)
                        })
                            .padding(.trailing, 12)
                            .tint(.nightSky2)
                    }
                    .padding(.bottom, 12)
                }
                .background(Color.sheep1)
                .cornerRadius(12)
                .padding(EdgeInsets(top: 0, leading: 16, bottom: 12, trailing: 16))
                
                if let subQuestionList = item.subquestionList {
                    ForEach(0 ..< subQuestionList.count, id: \.self) { i in
                        let subItem = item.subquestionList![i]
                        VStack(spacing: 0) {
                            HStack(spacing: 0) {
                                Text("질문")
                                    .frame(maxHeight: .infinity, alignment: .top)
                                    .font(.system(size: 15, weight: .regular, design: .default))
                                    .foregroundColor(.nightSky1)
                                Text(subItem.sentence)
                                    .frame(maxWidth: .infinity, alignment: .topLeading)
                                    .font(.system(size: 15, weight: .regular, design: .default))
                                    .padding(.leading, 12)
                            }
                            .padding(EdgeInsets(top: 12, leading: 8, bottom: 4, trailing: 8))
                            HStack(spacing: 0) {
                                Text("답변")
                                    .frame(maxHeight: .infinity, alignment: .top)
                                    .font(.system(size: 15, weight: .regular, design: .default))
                                    .foregroundColor(.nightSky1)
                                Text(subItem.answer)
                                    .frame(maxWidth: .infinity, alignment: .topLeading)
                                    .font(.system(size: 15, weight: .regular, design: .default))
                                    .padding(.leading, 12)
                            }
                            .padding(EdgeInsets(top: 0, leading: 8, bottom: 4, trailing: 8))
                            
                        }
                        .background(Color.sheep1)
                        .cornerRadius(12)
                        .padding(EdgeInsets(top: 0, leading: 28, bottom: 8, trailing: 16))
                    }
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
