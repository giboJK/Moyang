//
//  AddNewGroupView.swift
//  Moyang
//
//  Created by 정김기보 on 2022/02/19.
//

import SwiftUI

struct AddNewGroupView: View {
    @StateObject var vm: AddNewGroupVM
    @Environment(\.presentationMode) var presentationMode
    @State var newLeader = false
    @State var newMember = false
    
    var body: some View {
        
        VStack(spacing: 0) {
            Text("소속 공동체")
                .foregroundColor(.nightSky1)
                .font(.system(size: 16, weight: .semibold, design: .default))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(EdgeInsets(top: 20, leading: 24, bottom: 4, trailing: 24))
            PickerTextField(data: vm.divisionList,
                            placeholder: "소속 공동체",
                            lastSelectedIndex: $vm.selectedIndex)
                .padding(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8))
                .background(Color.sheep1)
                .frame(width: UIScreen.screenWidth - 32, height: 40, alignment: .center)
                .foregroundColor(.nightSky1)
                .cornerRadius(8)
                .padding(.bottom, 16)
            
            Text("그룹 이름")
                .foregroundColor(.nightSky1)
                .font(.system(size: 16, weight: .semibold, design: .default))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(EdgeInsets(top: 0, leading: 24, bottom: 4, trailing: 24))
            
            TextField("", text: $vm.name)
                .placeholder(when: vm.name.isEmpty) {
                    Text("그룹 이름").foregroundColor(.sheep4)
                }
                .padding(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8))
                .background(Color.sheep1)
                .frame(width: UIScreen.screenWidth - 32, height: 40, alignment: .center)
                .foregroundColor(.nightSky1)
                .cornerRadius(8)
                .padding(.bottom, 16)
            
            HStack(spacing: 0) {
                Text("리더 (\(vm.leaderCount)명)")
                    .foregroundColor(.nightSky1)
                    .font(.system(size: 16, weight: .semibold, design: .default))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(EdgeInsets(top: 0, leading: 24, bottom: 4, trailing: 24))
                Spacer()
                
                NavigationLink(destination: NewMemberSearchView(isLeaderSelectionMode: true,
                                                                vm: vm)) {
                    Image(systemName: "plus.app.fill")
                        .foregroundColor(.nightSky1)
                        .frame(width: 24, height: 24)
                        .padding(.trailing, 16)
                }
            }
            
            Text(vm.leaderListName.isEmpty ? "리더 없음" : vm.leaderListName)
                .foregroundColor(vm.leaderListName.isEmpty ? .sheep4 : .nightSky1)
                .padding(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 4))
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.sheep1)
                .cornerRadius(8)
                .font(.system(size: 16, weight: .semibold, design: .default))
                .padding(EdgeInsets(top: 0, leading: 16, bottom: 16, trailing: 16))
            
            HStack(spacing: 0) {
                Text("멤버 (\(vm.memberCount)명)")
                    .foregroundColor(.nightSky1)
                    .font(.system(size: 16, weight: .semibold, design: .default))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(EdgeInsets(top: 0, leading: 24, bottom: 4, trailing: 24))
                Spacer()
                
                NavigationLink(destination: NewMemberSearchView(isLeaderSelectionMode: false,
                                                                vm: vm)) {
                    Image(systemName: "plus.app.fill")
                        .foregroundColor(.nightSky1)
                        .frame(width: 24, height: 24)
                        .padding(.trailing, 16)
                }
            }
            Text(vm.memberListName.isEmpty ? "멤버 없음" : vm.memberListName)
                .foregroundColor(vm.memberListName.isEmpty ? .sheep4 : .nightSky1)
                .padding(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 4))
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.sheep1)
                .cornerRadius(8)
                .font(.system(size: 16, weight: .semibold, design: .default))
                .padding(EdgeInsets(top: 0, leading: 16, bottom: 16, trailing: 16))
            Spacer()
        }
        .navigationTitle("새 그룹 추가")
        .onReceive(vm.viewDismissalModePublisher) { shouldDismiss in
            if shouldDismiss {
                self.presentationMode.wrappedValue.dismiss()
            }
        }
        .frame(maxWidth: .infinity)
        .background(Color.sheep2)
        .toolbar {
            Button("완료") {
                vm.addNewGroup()
            }
        }
    }
}

struct AddNewGroupView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AddNewGroupView(vm: AddNewGroupVMMock())
        }
    }
}