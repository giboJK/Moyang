//
//  CommunityGroupCardView.swift
//  Moyang
//
//  Created by kibo on 2022/02/05.
//

import SwiftUI

struct CommunityGroupCardView: View {
    @ObservedObject var vm: CommunityGroupCardVM
    
    var body: some View {
        if vm.item.groupName.isEmpty {
            VStack(spacing: 0) {
                HStack {
                    Text("공동체")
                        .padding(.leading, 8)
                        .font(.system(size: 16, weight: .semibold, design: .default))
                        .foregroundColor(.nightSky1)
                    Spacer()
                }
                .padding(.bottom, 8)
                
                VStack(spacing: 0) {
                    Spacer()
                    Text("소속된 공동체가 없습니다.\n교역자에게 문의하세요.")
                        .multilineTextAlignment(.center)
                        .font(.system(size: 14, weight: .regular, design: .default))
                        .foregroundColor(.sheep4)
                    Spacer()
                }
                .frame(maxWidth: .infinity, idealHeight: 208, alignment: .center)
                .modifier(MainCard())
                .eraseToAnyView()
            }
        } else {
            VStack(spacing: 0) {
                HStack {
                    Text(vm.item.groupName)
                        .padding(.leading, 8)
                        .font(.system(size: 16, weight: .semibold, design: .default))
                        .foregroundColor(.nightSky1)
                    Spacer()
                    Image(systemName: "chevron.right")
                }
                .padding(.bottom, 8)
                
                VStack(spacing: 0) {
                    HStack {
                        Text(vm.item.meetingDate + " 나눔 질문")
                            .font(.system(size: 15, weight: .regular, design: .default))
                            .foregroundColor(.nightSky1)
                        Spacer()
                        Text("\(vm.item.answeredQuestionCount) / \(vm.item.totalQuestionCount)")
                            .font(.system(size: 15, weight: .regular, design: .default))
                            .foregroundColor(.nightSky1)
                    }.padding(EdgeInsets(top: 16, leading: 12, bottom: 8, trailing: 12))
                    Divider()
                        .background(Color.sheep3)
                        .padding(.bottom, 12)
                        
                    
                    ForEach(0..<min(2, vm.item.groupQuestion.count), id: \.self) { i in
                        let item = vm.item.groupQuestion[i]
                        if item.question.isAnswered {
                            HStack(spacing: 0) {
                                Image(systemName: "checkmark")
                                    .frame(width: 16, height: 16)
                                    .padding(.trailing, 4)
                                Text(item.question.sentence)
                                    .lineLimit(1)
                                    .font(.system(size: 15, weight: .regular, design: .default))
                            }
                        } else {
                            let sentence = item.question.sentence.isEmpty ?
                            "하위 질문" : item.question.sentence
                            Text("· \(sentence)")
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .font(.system(size: 15, weight: .regular, design: .default))
                                .lineLimit(1)
                        }
                    }
                    .padding(EdgeInsets(top: 0, leading: 16, bottom: 4, trailing: 16))
                    
                    HStack(spacing: 0) {
                        Text(vm.item.prayRegisterDate + " 기도")
                            .font(.system(size: 15, weight: .regular, design: .default))
                            .foregroundColor(.nightSky1)
                        Spacer()
                        Text("Last pray date:")
                            .font(.system(size: 14, weight: .regular, design: .default))
                            .foregroundColor(.sheep4)
                            .padding(.trailing, 4)
                        Text(vm.item.lastestPrayDate)
                            .font(.system(size: 14, weight: .regular, design: .default))
                            .foregroundColor(.sheep4)
                    }.padding(EdgeInsets(top: 16, leading: 12, bottom: 8, trailing: 12))
                    Divider()
                        .background(Color.sheep3)
                        .padding(.bottom, 12)
                    if let prayList = vm.item.prayList {
                        ForEach(0..<min(2, prayList.list.count), id: \.self) { i in
                            let item = prayList.list[i]
                            HStack(spacing: 0) {
                                Text("· \(item.member.name)")
                                    .font(.system(size: 15, weight: .regular, design: .default))
                                    .padding(.trailing, 4)
                                Text(item.pray)
                                    .font(.system(size: 15, weight: .regular, design: .default))
                                    .padding(.trailing, 4)
                            }
                        }
                    } else {
                        VStack(spacing: 0) {
                            Spacer()
                            Text("등록된 기도가 없습니다.")
                                .multilineTextAlignment(.center)
                                .font(.system(size: 14, weight: .regular, design: .default))
                                .foregroundColor(.sheep4)
                            Spacer()
                        }
                    }
                    Spacer()
                }
                .frame(maxWidth: .infinity, idealHeight: 208, alignment: .center)
                .modifier(MainCard())
                .eraseToAnyView()
            }
            
            //            VStack(spacing: 0) {
            //                HStack {
            //                    Text(vm.item.groupName)
            //                        .padding(.leading, 8)
            //                        .font(.system(size: 16, weight: .semibold, design: .default))
            //                        .foregroundColor(.nightSky1)
            //                    Spacer()
            //                    Image(systemName: "chevron.right")
            //                }
            //                .padding(.bottom, 8)
            //
            //                VStack(spacing: 0) {
            //                    HStack {
            //                        Text("2022.01.30 나눔질문")
            //                        Spacer()
            //                        Text("1 / 4")
            //                    }
            //                    Divider()
            //                    Text("· 오늘 본문을 보면서")
            //                        .frame(maxWidth: .infinity, alignment: .leading)
            //                    Text("· 귀신들린")
            //                        .frame(maxWidth: .infinity, alignment: .leading)
            //                    HStack {
            //                        Text("2022.01.30 기도")
            //                        Spacer()
            //                        Text("Last pray date: 2022.01.31")
            //                    }.padding(.top, 20)
            //                    Divider()
            //                    Text("· 정김기보: 부끄부끄")
            //                        .frame(maxWidth: .infinity, alignment: .leading)
            //                    Text("· 정김기보: 안 부끄부끄로")
            //                        .frame(maxWidth: .infinity, alignment: .leading)
            //                }
            //                .modifier(MainCard())
            //                .eraseToAnyView()
            //            }
        }
    }
}

struct CommunityGroupCardView_Previews: PreviewProvider {
    static var previews: some View {
        CommunityGroupCardView(vm: CommunityGroupCardVMMock())
    }
}
