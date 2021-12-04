//
//  NewCellPrayView.swift
//  Moyang
//
//  Created by 정김기보 on 2021/11/28.
//

import SwiftUI

struct NewCellPrayView: View {
    @ObservedObject var viewModel: NewCellPrayVM
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: true) {
            ForEach(0 ..< viewModel.memberNewPrayList.count) { i in
                HStack {
                    Text(viewModel.memberNewPrayList[i].name)
                    Spacer()
                }
                TextEditor(text: $viewModel.memberNewPrayList[i].pray)
                    .padding(.bottom, 10)
                    .font(.system(size: 14, weight: .regular, design: .default))
                    .frame(height: 55, alignment: .topLeading)
                    .colorMultiply(Color(UIColor.sheep))
                    .foregroundColor(viewModel.memberNewPrayList[i].pray == "기도제목을 입력하세요" ? .gray : .primary)
                    .onTapGesture {
                        if viewModel.memberNewPrayList[i].pray == "기도제목을 입력하세요" {
                            viewModel.memberNewPrayList[i].pray = ""
                        }
                    }
            }
        }.navigationBarTitle("새 기도제목")
    }
}

struct NewCellPrayView_Previews: PreviewProvider {
    static var previews: some View {
        NewCellPrayView(viewModel: NewCellPrayVM())
    }
}
