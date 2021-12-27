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
    @State private var showPrayTimePicker = false
    @State private var showAlarmPicker = false
    @State private var selection = 0
    
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
                TextField("시간을 골라요", text: $vm.prayTime) { onEditing in
                    self.showAlarmPicker = onEditing
                }
                
                if showAlarmPicker {
                    Picker(selection: $selection, label:
                        Text("Pick one:")
                        , content: {
                            ForEach(0 ..< values.count) { index in
                                Text(self.values[index])
                                    .tag(index)
                            }
                    })

                    Text("you have picked \(self.values[self.selection])")

                    Button(action: {
                        vm.prayTime = self.values[self.selection]
                    }, label: {
                        Text("Done")
                    })
                }
            }
            Divider()
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
    }
}

struct PrayAddView_Previews: PreviewProvider {
    static var previews: some View {
        PrayAddView(vm: PrayAddVM(prayRepo: PrayRepoImpl()))
    }
}
