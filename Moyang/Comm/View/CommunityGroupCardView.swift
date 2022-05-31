//
//  CommunityGroupCardView.swift
//  Moyang
//
//  Created by kibo on 2022/02/05.
//

import SwiftUI

struct CommunityGroupCardView: View {
    @StateObject var vm: CommunityGroupCardVM
    @State private var isShowingPopover = false
    
    var body: some View {
        if vm.groupName.isEmpty {
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
                        .font(.system(size: 15, weight: .regular, design: .default))
                        .foregroundColor(.sheep4)
                    Spacer()
                }
                .frame(maxWidth: .infinity, idealHeight: 208, alignment: .center)
                .modifier(MainCard())
                .eraseToAnyView()
            }
        } else {
            VStack(spacing: 0) {
                HStack(spacing: 0) {
                    Text("공동체안에서 함께해요")
                        .padding(.leading, 8)
                        .font(.system(size: 16, weight: .semibold, design: .default))
                        .foregroundColor(.nightSky1)
                    Button(action: {
                        self.isShowingPopover = true
                    }) {
                        Image(systemName: "info.circle")
                            .padding(.leading, 4)
                            .font(.system(size: 14, weight: .regular, design: .default))
                            .foregroundColor(.nightSky3)
                    }
                    .alwaysPopover(isPresented: $isShowingPopover) {
                        GroupCardPopover()
                    }
                    Spacer()
                    Button(action: {}) {
                        NavigationLink(destination: NavigationLazyView(CommunityList())) {
                            Text("모두 보기")
                                .foregroundColor(.sheep4)
                                .font(.system(size: 15, weight: .regular, design: .default))
                                .padding(EdgeInsets(top: 4, leading: 0, bottom: 0, trailing: 4))
                        }
                    }
                }
                .padding(.bottom, 8)
                
                VStack(spacing: 0) {
                    HStack(spacing: 0) {
                        Text(vm.groupName)
                            .font(.system(size: 15, weight: .regular, design: .default))
                            .foregroundColor(.nightSky1)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .font(.system(size: 14, weight: .semibold, design: .default))
                            .foregroundColor(.nightSky1)
                    }.padding(EdgeInsets(top: 12, leading: 12, bottom: 8, trailing: 12))
                    Divider()
                        .background(Color.sheep3)
                        .padding(.bottom, 12)
                    
                    ForEach(0..<min(2, vm.sermonItem.groupQuestion.count), id: \.self) { i in
                        let item = vm.sermonItem.groupQuestion[i]
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
                        Text(vm.prayItem.prayRegisterDate + " 기도")
                            .font(.system(size: 15, weight: .regular, design: .default))
                            .foregroundColor(.nightSky1)
                        Spacer()
                        Text("Last pray date:")
                            .font(.system(size: 14, weight: .regular, design: .default))
                            .foregroundColor(.sheep4)
                            .padding(.trailing, 4)
                        Text(vm.prayItem.lastestPrayDate)
                            .font(.system(size: 14, weight: .regular, design: .default))
                            .foregroundColor(.sheep4)
                    }.padding(EdgeInsets(top: 16, leading: 12, bottom: 8, trailing: 12))
                    Divider()
                        .background(Color.sheep3)
                        .padding(.bottom, 12)
                    if let prayList = vm.prayItem.prayList {
                        ForEach(0..<min(4, prayList.list.count), id: \.self) { i in
                            let item = prayList.list[i]
                            HStack(spacing: 0) {
                                Text("· \(item.member.name)")
                                    .font(.system(size: 16, weight: .regular, design: .default))
                                    .padding(EdgeInsets(top: 0, leading: 12, bottom: 0, trailing: 8))
                                Text(item.pray)
                                    .font(.system(size: 16, weight: .regular, design: .default))
                                    .truncationMode(.tail)
                                    .lineLimit(1)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.trailing, 12)
                            }
                            .padding(.bottom, 4)
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
                .frame(maxWidth: .infinity, alignment: .center)
                .modifier(MainCard())
                .eraseToAnyView()
            }
        }
    }
}

struct GroupCardPopover: View {
    var body: some View {
        Text("매번 유저가 속한 공동체 중 한 공동체가 노출됩니다.")
            .font(.system(size: 14, weight: .regular, design: .default))
            .foregroundColor(.nightSky3)
            .padding()
            .background(Color.sheep1)
    }
}
