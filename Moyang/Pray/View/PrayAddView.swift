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
    
    @State var arrGenders = ["Male","Female","Unknown"]
    @State var selectionIndex = 0
    @FocusState var isPraySubjectInputActive: Bool
    @FocusState var isPrayTimeInputActive: Bool
    
    var values = ["V1", "V2", "V3"]
    
    var body: some View {
        VStack {
            HStack {
                Text("기도 제목")
                    .font(.system(size: 16, weight: .regular))
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
                Text("요일")
                    .font(.system(size: 16, weight: .regular))
                Spacer()
            }
            HStack {
                Text("기도 시간")
                    .font(.system(size: 16, weight: .regular))
                Spacer()
            }
            HStack {
                Text("알람")
                    .font(.system(size: 16, weight: .regular))
                Spacer()
            }
            HStack {
                Text("알람 시간")
                    .font(.system(size: 16, weight: .regular))
                Spacer()
                TextFieldWithPickerInputView(data: self.arrGenders,
                                             placeholder: "select your gender",
                                             selectionIndex: self.$selectionIndex,
                                             text: $vm.alarmTime)
            }
            HStack {
                Text("Select a date")
                DatePicker(selection: $birthDate, in: ...Date(), displayedComponents: .date) {
                    Text("date")
                }
                Text("Birth date is \(birthDate, formatter: dateFormatter)")
            }.labelsHidden()
            HStack {
                Spacer()
                Text("기도를 작성하기 어려우신가요?")
                Image(systemName: "info.circle")
            }
        }
        .navigationBarTitle("새 기도제목")
        .navigationBarItems(trailing: Button("완료", action: {
            vm.addPray()
        }))
        .background(Color(UIColor.bgColor))
    }
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter
    }
    
    @State private var birthDate = Date()
    
}

struct PrayAddView_Previews: PreviewProvider {
    static var previews: some View {
        PrayAddView(vm: PrayAddVM(prayRepo: PrayRepoImpl()))
    }
}
