//
//  PrayListView.swift
//  Moyang
//
//  Created by 정김기보 on 2021/10/11.
//  Copyright © 2021 정김기보. All rights reserved.
//

import SwiftUI

struct PrayListView: View {
    @ObservedObject var viewModel: PrayListViewModel
    @State private var editingPraySubject = false
    @State private var newPraySubject = false
    @State private var isAlarmOn = true
    @State private var praySubject: String =
"""
나를 지으신 하나님. 오직 하나님만 경외하게 하소서.
기도 제목 감사감사 감사감사 감사감사 감사감사
"""
    var body: some View {
        VStack {
            NavigationLink(destination: PrayAddView(), isActive: $editingPraySubject) { EmptyView() }
            NavigationLink(destination: PrayAddView(), isActive: $newPraySubject) { EmptyView() }
            
            HStack {
                Spacer()
                Button(action: {
                    editingPraySubject.toggle()
                }, label: {
                    Image(systemName: "pencil")
                        .accessibilityLabel("Editing selected pray")
                        .foregroundColor(Color.black)
                        .padding(.trailing, 20)
                })
            }
            ScrollView(.vertical, showsIndicators: false) {
                NavigationLink(destination: PrayView()) {
                    Text(praySubject)
                        .frame(width: UIScreen.screenWidth - 40, alignment: .topLeading)
                        .foregroundColor(.black)
                        .multilineTextAlignment(.leading)
                        .font(.system(size: 16, weight: .regular))
                }
                HStack {
                    Text("오후 10시 00분")
                        .padding(.leading, 20)
                    Spacer()
                    Text("월 화 수 목 금 토")
                        .padding(.trailing, 10)
                    Toggle("", isOn: $isAlarmOn)
                        .padding(.trailing, 20)
                        .labelsHidden()
                        .toggleStyle(SwitchToggleStyle(tint: Color(Asset.Colors.Dessert.lightSand.color)))
                }
                .padding(.top, 3)

            }
            .frame(height: 140)
            .padding(.bottom, 15)
            Divider()
            
            Spacer()
        }
        .navigationBarItems(trailing: Button(action: { newPraySubject.toggle()},
                                             label: {
            Image(systemName: "plus")
                .accessibilityLabel("Adding a new pray")
                .foregroundColor(Color.black)
        }))
        .padding(.top, 34)
        .background(Color(Asset.Colors.Bg.bgColorGray.color))
    }
}

struct PrayListView_Previews: PreviewProvider {
    static var previews: some View {
        PrayListView(viewModel: PrayListViewModel(prayRepo: PrayRepoImpl()))
    }
}
