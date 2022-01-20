//
//  NewCellPrayView.swift
//  Moyang
//
//  Created by 정김기보 on 2021/11/28.
//

import SwiftUI

struct NewCellPrayView: View {
    @ObservedObject var vm: NewCellPrayVM
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: true) {
            ForEach(0 ..< vm.itemList.count) { i in
                HStack {
                    Text(vm.itemList[i].name)
                        .font(.body)
                        .foregroundColor(.sky1)
                    Spacer()
                }
                .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
                TextEditor(text: $vm.itemList[i].pray)
                    .font(.system(size: 14, weight: .regular, design: .default))
                    .frame(height: 55, alignment: .topLeading)
                    .foregroundColor(vm.itemList[i].pray == "기도제목을 입력하세요" ? .gray : .sky1)
                    .onTapGesture {
                        if vm.itemList[i].pray == "기도제목을 입력하세요" {
                            vm.itemList[i].pray = ""
                        }
                    }
                    .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
                Spacer(minLength: 10)
            }
        }
        .frame(maxWidth: .infinity)
        .background(Color.sheep1)
        .navigationBarTitle("새 기도제목")
        .toolbar {
            Button("추가") {
                vm.addNewPray()
            }
        }
    }
}

struct NewCellPrayView_Previews: PreviewProvider {
    static var previews: some View {
        NewCellPrayView(vm: NewCellPrayVM())
    }
}
