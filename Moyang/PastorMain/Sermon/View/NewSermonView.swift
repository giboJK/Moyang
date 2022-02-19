//
//  NewSermonView.swift
//  Moyang
//
//  Created by kibo on 2022/02/06.
//

import SwiftUI

struct NewSermonView: View {
    @ObservedObject var vm: NewSermonVM = NewSermonVM()
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
                        .foregroundColor(.nightSky1)
                        .padding(.leading, 24)
                        .padding(.bottom, 4)
                    TextField("", text: $vm.title)
                        .placeholder(when: vm.title.isEmpty) {
                            Text("제목").foregroundColor(.sheep4)
                        }
                        .padding(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8))
                        .background(Color.sheep1)
                        .frame(width: UIScreen.screenWidth - 32, height: 40, alignment: .center)
                        .foregroundColor(.nightSky1)
                        .cornerRadius(8)
                        .padding(.bottom, 16)
                    
                    Text("부제목")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.system(size: 16, weight: .semibold, design: .default))
                        .foregroundColor(.nightSky1)
                        .padding(.leading, 24)
                        .padding(.bottom, 4)
                    TextField("", text: $vm.subtitle)
                        .placeholder(when: vm.subtitle.isEmpty) {
                            Text("부제목").foregroundColor(.sheep4)
                        }
                        .padding(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8))
                        .background(Color.sheep1)
                        .frame(width: UIScreen.screenWidth - 32, height: 40, alignment: .center)
                        .foregroundColor(.nightSky1)
                        .cornerRadius(8)
                        .padding(.bottom, 16)
                    
                    Text("말씀 구절")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.system(size: 16, weight: .semibold, design: .default))
                        .foregroundColor(.nightSky1)
                        .padding(.leading, 24)
                        .padding(.bottom, 4)
                    TextField("", text: $vm.bible)
                        .placeholder(when: vm.bible.isEmpty) {
                            Text("말씀 구절").foregroundColor(.sheep4)
                        }
                        .padding(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8))
                        .background(Color.sheep1)
                        .frame(width: UIScreen.screenWidth - 32, height: 40, alignment: .center)
                        .foregroundColor(.nightSky1)
                        .cornerRadius(8)
                        .padding(.bottom, 16)
                    
                    Text("예배")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.system(size: 16, weight: .semibold, design: .default))
                        .foregroundColor(.nightSky1)
                        .padding(.leading, 24)
                        .padding(.bottom, 4)
                    TextField("", text: $vm.worship)
                        .placeholder(when: vm.worship.isEmpty) {
                            Text("예배").foregroundColor(.sheep4)
                        }
                        .padding(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8))
                        .background(Color.sheep1)
                        .frame(width: UIScreen.screenWidth - 32, height: 40, alignment: .center)
                        .foregroundColor(.nightSky1)
                        .cornerRadius(8)
                        .padding(.bottom, 16)
                    
                    GroupQuestionList(vm: vm.groupQuestionListVM)
                        .padding(.bottom, 64)
                }
            }
            VStack(spacing: 0) {
                Spacer()
                Button(action: {
                    vm.addSermon()
                }) {
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
        .onReceive(vm.viewDismissalModePublisher) { shouldDismiss in
            if shouldDismiss {
                self.presentationMode.wrappedValue.dismiss()
            }
        }
        .frame(maxWidth: .infinity)
        .background(Color.sheep2)
    }
}

struct NewSermonView_Previews: PreviewProvider {
    static var previews: some View {
        NewSermonView(vm: NewSermonVMMock())
    }
}
