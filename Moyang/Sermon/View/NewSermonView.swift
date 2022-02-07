//
//  NewSermonView.swift
//  Moyang
//
//  Created by kibo on 2022/02/06.
//

import SwiftUI

struct NewSermonView: View {
    @ObservedObject var vm: NewSermonVM
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 0) {
                    HStack {
                        Spacer()
                        DatePicker(selection: $vm.date, in: ...Date(), displayedComponents: .date) {
                        }
                        .accentColor(.ydGreen1)
                        .cornerRadius(12)
                        .padding(EdgeInsets(top: 12, leading: 0, bottom: -4, trailing: 16))
                    }
                    Text("제목")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.system(size: 16, weight: .semibold, design: .default))
                        .padding(.leading, 24)
                        .padding(.bottom, 4)
                    TextField("", text: $vm.title)
                        .placeholder(when: vm.title.isEmpty) {
                            Text("제목을 입력하세요").foregroundColor(.sheep4)
                        }
                        .padding(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8))
                        .background(Color.sheep1)
                        .frame(width: UIScreen.screenWidth - 32, height: 40, alignment: .center)
                        .foregroundColor(.nightSky1)
                        .cornerRadius(8)
                        .padding(.bottom, 20)
                    
                    Text("부제목")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.system(size: 16, weight: .semibold, design: .default))
                        .padding(.leading, 24)
                        .padding(.bottom, 4)
                    TextField("", text: $vm.subtitle)
                        .placeholder(when: vm.title.isEmpty) {
                            Text("부제목을 입력하세요").foregroundColor(.sheep4)
                        }
                        .padding(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8))
                        .background(Color.sheep1)
                        .frame(width: UIScreen.screenWidth - 32, height: 40, alignment: .center)
                        .foregroundColor(.nightSky1)
                        .cornerRadius(8)
                        .padding(.bottom, 20)
                    
                    Text("말씀 구절")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.system(size: 16, weight: .semibold, design: .default))
                        .padding(.leading, 24)
                        .padding(.bottom, 4)
                    TextField("", text: $vm.bible)
                        .placeholder(when: vm.title.isEmpty) {
                            Text("말씀 구절을 입력하세요").foregroundColor(.sheep4)
                        }
                        .padding(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8))
                        .background(Color.sheep1)
                        .frame(width: UIScreen.screenWidth - 32, height: 40, alignment: .center)
                        .foregroundColor(.nightSky1)
                        .cornerRadius(8)
                        .padding(.bottom, 20)
                    HStack {
                        Text("질문 목록")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .font(.system(size: 16, weight: .semibold, design: .default))
                            .padding(.leading, 24)
                        Spacer()
                        Button(action: {}, label: {
                            Image(systemName: "plus.app.fill")
                                .foregroundColor(.nightSky1)
                        })
                            .frame(width: 24, height: 24)
                            .padding(.trailing, 16)
                    }
                    .padding(.bottom, 4)
                    ForEach(0 ..< vm.groupQuestionList.count) { i in
                        let item = vm.groupQuestionList[i]
                    }
                }
            }
            VStack(spacing: 0) {
                Spacer()
                Button(action: {}) {
                    Text("완료")
                        .frame(width: UIScreen.screenWidth - 80,
                               height: 50)
                }
                .buttonStyle(MoyangButtonStyle(width: UIScreen.screenWidth - 80,
                                               height: 50))
                .padding(.bottom, 10)
                
            }
        }
        .navigationTitle("새 설교")
        .frame(maxWidth: .infinity)
        .background(Color.sheep2)
    }
}

struct NewSermonView_Previews: PreviewProvider {
    static var previews: some View {
        NewSermonView(vm: NewSermonVMMock())
    }
}
