//
//  NewMyPrayView.swift
//  Moyang
//
//  Created by kibo on 2022/04/24.
//

import SwiftUI

struct NewMyPrayView: View {
    @StateObject var vm: NewMyPrayVM
    @FocusState private var focus: Bool
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                Text(vm.name)
                    .foregroundColor(.nightSky1)
                    .font(.system(size: 16, weight: .regular, design: .default))
                Spacer()
                DatePicker(selection: $vm.date, in: ...Date(), displayedComponents: .date) {}
            }
            .padding(EdgeInsets(top: 12, leading: 24, bottom: 16, trailing: 20))
            
            TextEditor(text: $vm.pray)
                .font(.system(size: 15, weight: .regular, design: .default))
                .focused($focus)
                .frame(height: .infinity, alignment: .topLeading)
                .foregroundColor(.nightSky1)
                .background(Color.sheep2)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.sheep4, lineWidth: 1)
                )
                .padding(EdgeInsets(top: 0, leading: 20, bottom: 24, trailing: 20))
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .background(Color.sheep1)
        .navigationBarTitle("새 기도제목")
        .toolbar {
            Button("추가") {
                vm.addNewPray()
            }
        }
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button("완료") { focus = false }
            }
        }
        .onReceive(vm.viewDismissalModePublisher) { shouldDismiss in
            if shouldDismiss {
                self.presentationMode.wrappedValue.dismiss()
            }
        }
    }
}

struct NewMyPrayView_Previews: PreviewProvider {
    static var previews: some View {
        NewMyPrayView(vm: NewMyPrayVM(repo: GroupRepoImpl(service: FSServiceImpl()),
                                      groupInfo: nil))
    }
}
