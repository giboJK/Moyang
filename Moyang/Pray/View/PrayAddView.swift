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
    @State private var praySubject: String = ""
    
    var body: some View {
        VStack {
            HStack {
                Text("새 기도 제목")
                    .font(.system(size: 20, weight: .bold))
                Spacer()
            }
            .padding(EdgeInsets(top: 0, leading: 0, bottom: 15, trailing: 0))
            HStack {
                Text("시작 날짜")
                    .font(.system(size: 16, weight: .regular))
                Spacer()
                Text(Date().toString("yyyy년 MM월 dd일")) // 기도를 작성한 날짜 표시
                    .padding(.leading, 20)
                    .font(.system(size: 16, weight: .regular))
                    .onTapGesture(perform: {
                        // 달력 뷰를 띄울까?
                    })
            }
            .padding(EdgeInsets(top: 0, leading: 0, bottom: 5, trailing: 0))
            ZStack(alignment: .topLeading) {
                TextEditor(text: vm.$praySubject)
                    .multilineTextAlignment(.leading)
                    .font(.system(size: 16, weight: .regular))
                    .frame(maxWidth: UIScreen.screenWidth, maxHeight: 180, alignment: .topLeading)
                if vm.praySubject.isEmpty {
                    Text("기도 제목을 적어보세요")
                        .foregroundColor(Color(UIColor.placeholderText))
                        .padding(.horizontal, 4)
                        .padding(.vertical, 8)
                }
            }
            Divider()
            
            Divider()
            HStack {
                Text("기도제목 작성 도우미를 이용해보세요.")
                Image(systemName: "info.circle")
                Spacer()
            }
            
            
            Spacer()
        }
        .padding(EdgeInsets(top: 34, leading: 20, bottom: 0, trailing: 20))
        .background(Color(UIColor.bgColor))
    }
}

struct PrayAddView_Previews: PreviewProvider {
    static var previews: some View {
        PrayAddView(vm: PrayAddVM())
    }
}
