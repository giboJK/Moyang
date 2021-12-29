//
//  PrayAddView.swift
//  Moyang
//
//  Created by 정김기보 on 2021/10/16.
//  Copyright © 2021 정김기보. All rights reserved.
//

import SwiftUI

struct PrayAddView: View {
    @ObservedObject var vm: PrayAddVM

    @FocusState var isPraySubjectInputActive: Bool
    @FocusState var isPrayTimeInputActive: Bool
    
    var body: some View {
        VStack {
            HStack {
                Text("기도 제목")
                    .font(.system(size: 18, weight: .regular))
                Spacer()
            }
            .padding(EdgeInsets(top: 0, leading: 0, bottom: 5, trailing: 0))
            ZStack(alignment: .topLeading) {
                TextEditor(text: $vm.praySubject)
                    .multilineTextAlignment(.leading)
                    .font(.system(size: 16, weight: .regular))
                    .frame(maxWidth: UIScreen.screenWidth, maxHeight: 180, alignment: .topLeading)
                    .focused($isPraySubjectInputActive)
                    .toolbar {
                        ToolbarItemGroup(placement: .keyboard) {
                            Spacer()
                            Button("완료") {
                                isPraySubjectInputActive = false
                            }
                        }
                    }
                if vm.praySubject.isEmpty {
                    Text("하나님과 나눌 대화를 적어보세요")
                        .foregroundColor(Color(UIColor.placeholderText))
                        .padding(.horizontal, 4)
                        .padding(.vertical, 8)
                }
            }
            Divider()
            HStack {
                ForEach(PrayDay.allCases) { day in
                    Button(day.rawValue, action: {
                        if vm.prayDayList.contains(day.dayCode) {
                            vm.prayDayList.removeAll { $0 == day.dayCode }
                        } else {
                            vm.prayDayList.append(day.dayCode)
                        }
                    })
                        .frame(maxWidth: .infinity)
                        .frame(height: 40)
                        .font(.system(size: 18, weight: .regular))
                        .foregroundColor(vm.prayDayList.contains(day.dayCode) ? .white : day.textColor)
                        .background(vm.prayDayList.contains(day.dayCode) ? .gray : .white)
                        .clipShape(Circle())
                }
            }
            HStack {
                Text("기도 시간")
                    .font(.system(size: 18, weight: .regular))
                Spacer()
                Picker("Pray time", selection: $vm.prayTime) {
                    ForEach(PrayTime.allCases) { flavor in
                        Text(flavor.rawValue.capitalized)
                    }
                }
            }
            HStack {
                Text("알람")
                    .font(.system(size: 18, weight: .regular))
                Spacer()
            }
            HStack {
                DatePicker(selection: $vm.alarmTime, displayedComponents: .hourAndMinute) {
                    Text("알람 시간")
                        .font(.system(size: 18, weight: .regular))
                }
            }
            HStack {
                Spacer()
                Text("기도를 작성하기 어려우신가요?")
                Image(systemName: "info.circle")
            }
            Spacer()
        }
        .navigationBarTitle("새 기도제목")
        .navigationBarItems(trailing: Button("완료", action: {
            vm.addPray()
        }))
        .background(Color(UIColor.bgColor))
        .padding(EdgeInsets(top: 10, leading: 20, bottom: 20, trailing: UIApplication.bottomInset))
    }
}

struct PrayAddView_Previews: PreviewProvider {
    static var previews: some View {
        PrayAddView(vm: PrayAddVM(prayRepo: PrayRepoImpl()))
    }
}
