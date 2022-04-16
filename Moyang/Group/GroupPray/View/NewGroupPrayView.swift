//
//  NewGroupPrayView.swift
//  Moyang
//
//  Created by 정김기보 on 2021/11/28.
//

import SwiftUI

struct NewGroupPrayView: View {
    @StateObject var vm: NewGroupPrayVM
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: true) {
            HStack {
                DatePicker(selection: $vm.date, in: ...Date(), displayedComponents: .date) {
                    Text("날짜")
                        .font(.system(size: 16, weight: .regular, design: .default))
                        .foregroundColor(.nightSky1)
                }
            }
            .padding(EdgeInsets(top: 4, leading: 20, bottom: 8, trailing: 20))
            
            ForEach(vm.itemList.indices, id: \.self) { i in
                VStack(spacing: 0) {
                    HStack {
                        Text(vm.itemList[i].member.name)
                            .font(.body)
                            .font(.system(size: 15, weight: .regular, design: .default))
                            .foregroundColor(.nightSky1)
                        Spacer()
                    }
                    .padding(EdgeInsets(top: 0, leading: 20, bottom: 4, trailing: 20))
                    TextEditor(text: $vm.itemList[i].pray)
                        .font(.system(size: 14, weight: .regular, design: .default))
                        .frame(minHeight: 88, alignment: .topLeading)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.sheep4, lineWidth: 1)
                        )
                        .foregroundColor(vm.itemList[i].pray == "기도제목을 입력하세요" ? .gray : .nightSky1)
                        .onTapGesture {
                            if vm.itemList[i].pray == "기도제목을 입력하세요" {
                                vm.itemList[i].pray = ""
                            }
                        }
                        .padding(EdgeInsets(top: 0, leading: 20, bottom: 12, trailing: 20))
                }
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
        .onReceive(vm.viewDismissalModePublisher) { shouldDismiss in
            if shouldDismiss {
                self.presentationMode.wrappedValue.dismiss()
            }
        }
    }
}

struct NewCellPrayView_Previews: PreviewProvider {
    static var previews: some View {
        NewGroupPrayView(vm: NewGroupPrayVM(repo: GroupRepoImpl(service: FSServiceImpl()),
                                            groupInfo: nil))
    }
}
