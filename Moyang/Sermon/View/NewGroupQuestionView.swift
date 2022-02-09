//
//  NewGroupQuestionView.swift
//  Moyang
//
//  Created by 정김기보 on 2022/02/08.
//

import SwiftUI

struct NewGroupQuestionView: View {
    @ObservedObject var vm: GroupQuestionListVM
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    var index: Int
    var isEdit: Bool
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                Text("질문 \(index + 1)")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.system(size: 16, weight: .semibold, design: .default))
                    .foregroundColor(.nightSky1)
                    .padding(EdgeInsets(top: 20, leading: 24, bottom: 4, trailing: 0))
                
                TextEditor(text: $vm.groupQuestionList[index].question.sentence)
                    .font(.system(size: 15, weight: .regular, design: .default))
                    .foregroundColor(vm.groupQuestionList[index].question.sentence == "입력하세요" ? .sheep4 : .nightSky1)
                    .onTapGesture {
                        if vm.groupQuestionList[index].question.sentence == "입력하세요" {
                            vm.groupQuestionList[index].question.sentence = ""
                        }
                    }
                    .frame(width: .infinity, height: 80, alignment: .topLeading)
                    .cornerRadius(12)
                    .padding(EdgeInsets(top: 4, leading: 16, bottom: 16, trailing: 16))
                
                Text("답변")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.system(size: 16, weight: .semibold, design: .default))
                    .foregroundColor(.nightSky1)
                    .padding(.leading, 24)
                    .padding(.bottom, 4)
                TextEditor(text: $vm.groupQuestionList[index].question.answer)
                    .font(.system(size: 15, weight: .regular, design: .default))
                    .foregroundColor(vm.groupQuestionList[index].question.answer == "입력하세요" ? .sheep4 : .nightSky1)
                    .onTapGesture {
                        if vm.groupQuestionList[index].question.answer == "입력하세요" {
                            vm.groupQuestionList[index].question.answer = ""
                        }
                    }
                    .frame(width: .infinity, height: 80, alignment: .topLeading)
                    .cornerRadius(12)
                    .padding(EdgeInsets(top: 4, leading: 16, bottom: 16, trailing: 16))
                
                HStack {
                    Text("하위 질문")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.system(size: 16, weight: .semibold, design: .default))
                        .foregroundColor(.nightSky1)
                        .padding(.leading, 24)
                    Spacer()
                    Button(action: {
                        vm.addSubQuestion(index: index)
                    }, label: {
                        Image(systemName: "plus.app.fill")
                            .foregroundColor(.nightSky1)
                    })
                        .frame(width: 24, height: 24)
                        .padding(.trailing, 16)
                }
                .padding(.bottom, 4)
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 0) {
                        ForEach(0..<$vm.groupQuestionList[index].subquestionList.count, id: \.self) { i in
                            Text("질문 \(i + 1)")
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .font(.system(size: 15, weight: .regular, design: .default))
                                .foregroundColor(.nightSky1)
                                .padding(EdgeInsets(top: 0, leading: 8, bottom: 4, trailing: 0))
                            
                            TextEditor(text: $vm.groupQuestionList[index].subquestionList[i].sentence)
                                .font(.system(size: 15, weight: .regular, design: .default))
                                .foregroundColor(vm.groupQuestionList[index].subquestionList[i].sentence == "입력하세요" ? .sheep4 : .nightSky1)
                                .onTapGesture {
                                    if vm.groupQuestionList[index].subquestionList[i].sentence == "입력하세요" {
                                        vm.groupQuestionList[index].subquestionList[i].sentence = ""
                                    }
                                }
                                .frame(width: .infinity, height: 70, alignment: .topLeading)
                                .cornerRadius(12)
                                .padding(.bottom, 8)
                            
                            Text("답변")
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .frame(maxHeight: .infinity, alignment: .top)
                                .font(.system(size: 15, weight: .regular, design: .default))
                                .foregroundColor(.nightSky1)
                                .padding(EdgeInsets(top: 0, leading: 8, bottom: 4, trailing: 0))
                            
                            TextEditor(text: $vm.groupQuestionList[index].subquestionList[i].answer)
                                .font(.system(size: 15, weight: .regular, design: .default))
                                .foregroundColor(vm.groupQuestionList[index].subquestionList[i].sentence == "입력하세요" ? .sheep4 : .nightSky1)
                                .onTapGesture {
                                    if vm.groupQuestionList[index].subquestionList[i].answer == "입력하세요" {
                                        vm.groupQuestionList[index].subquestionList[i].answer = ""
                                    }
                                }
                                .frame(width: .infinity, height: 70, alignment: .topLeading)
                                .cornerRadius(12)
                                .padding(.bottom, 8)
                            Divider()
                                .padding(.bottom, 8)
                        }
                    }
                }
                .padding(EdgeInsets(top: 0, leading: 16, bottom: 68, trailing: 16))
            }
            VStack(spacing: 0) {
                Spacer()
                Button(action: {}) {
                    NavigationLink(destination: NewSermonView(vm: NewSermonVM())) {
                        Text("설교 추가")
                            .frame(width: UIScreen.screenWidth - 80,
                                   height: 50)
                    }
                }.buttonStyle(MoyangButtonStyle(width: UIScreen.screenWidth - 80,
                                                height: 50))
                    .padding(.bottom, 10)
            }
        }
        .navigationBarTitle(isEdit ? "질문 수정": "새 질문")
        .navigationBarItems(trailing: Button(isEdit ? "삭제": "", action: {
            self.mode.wrappedValue.dismiss()
            vm.deleteQuestion(index: index)
        }).foregroundColor(.appleRed1)
        )
        .frame(maxWidth: .infinity)
        .background(Color.sheep2)
    }
}

struct NewGroupQuestionView_Previews: PreviewProvider {
    static var previews: some View {
        NewGroupQuestionView(vm: GroupQuestionListVMMock(), index: 0, isEdit: true)
    }
}
