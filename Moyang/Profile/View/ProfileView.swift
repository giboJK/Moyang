//
//  ProfileView.swift
//  Moyang
//
//  Created by kibo on 2022/01/14.
//

import SwiftUI

struct ProfileView: View {
    @StateObject var vm: ProfileVM

    @Binding var rootIsActive: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                Image(systemName: "person.crop.circle")
                    .font(.system(size: 64, weight: .regular))
                    .padding(EdgeInsets(top: 0, leading: 24, bottom: 0, trailing: 16))
                    .tint(.nightSky1)
                
                VStack(spacing: 0) {
                    Text(vm.groupInfoItem.name + "님,\n안녕하세요")
                        .foregroundColor(.nightSky1)
                        .font(.system(size: 18, weight: .bold, design: .default))
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text(vm.levelDesc)
                        .foregroundColor(.ydGreen1)
                        .font(.system(size: 15, weight: .regular, design: .default))
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .padding(.bottom, 20)
            
            VStack(spacing: 0) {
                Button(action: {}) {
                    NavigationLink(destination: MyInfoView(vm: vm)) {
                        Text("내 정보")
                            .padding(.leading, 32)
                            .font(.system(size: 16, weight: .regular, design: .default))
                            .foregroundColor(.nightSky1)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .frame(height: 50)
                    }
                }
                .background(Color.sheep1)
                Divider()
                    .background(Color.sheep3)
                    .padding(.leading, 28)
                
                Button(action: {
    //                UserData.shared.resetUserData()
    //                self.rootIsActive = false
                }) {
                    Text("공동체")
                        .padding(.leading, 32)
                        .font(.system(size: 16, weight: .regular, design: .default))
                        .foregroundColor(.nightSky1)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .frame(height: 50)
                }
                .background(Color.sheep1)
                Divider()
                    .background(Color.sheep3)
                    .padding(.leading, 28)
                
                HStack(spacing: 0) {
                    Text("기도 시간")
                        .padding(.leading, 32)
                        .font(.system(size: 16, weight: .regular, design: .default))
                        .foregroundColor(.nightSky1)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .frame(height: 50)
                    Spacer()
                        .frame(maxWidth: .infinity)
                    
                    DatePicker("", selection: $vm.alarmDate, displayedComponents: .hourAndMinute)
                        .accentColor(.ydGreen1)
                        .colorInvert()
                        .colorMultiply(vm.isAlarmOn ? .ydGreen1 : .sheep4)
                        .onChange(of: vm.alarmDate) { _ in
                            vm.setAlarmTime()
                        }
                    
                    Button(action: {
                        vm.toggleAlarmOn()
                    }) {
                        Toggle("", isOn: $vm.isAlarmOn)
                            .padding(.trailing, 24)
                            .toggleStyle(SwitchToggleStyle(tint: .ydGreen1))
                    }
                    .background(Color.sheep1)
                }
                .background(Color.sheep1)
                
                Divider()
                    .background(Color.sheep3)
                    .padding(.leading, 28)
                
                Button(action: {
    //                UserData.shared.resetUserData()
    //                self.rootIsActive = false
                }) {
                    Text("공지사항")
                        .padding(.leading, 32)
                        .font(.system(size: 16, weight: .regular, design: .default))
                        .foregroundColor(.nightSky1)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .frame(height: 50)
                }
                .background(Color.sheep1)
                Divider()
                    .background(Color.sheep3)
                    .padding(.leading, 28)
                
                Button(action: {
    //                UserData.shared.resetUserData()
    //                self.rootIsActive = false
                }) {
                    Text("문의하기")
                        .padding(.leading, 32)
                        .font(.system(size: 16, weight: .regular, design: .default))
                        .foregroundColor(.nightSky1)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .frame(height: 50)
                }
                .background(Color.sheep1)
                .padding(.bottom, 24)
                
                Button(action: {
                    vm.logout()
                }) {
                    Text("로그아웃")
                        .padding(.leading, 32)
                        .font(.system(size: 16, weight: .regular, design: .default))
                        .foregroundColor(.nightSky1)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .frame(height: 50)
                }
                .background(Color.sheep1)
            }
            
            Spacer()
        }
        .padding(.top, 30)
        .frame(maxWidth: .infinity)
        .background(Color.sheep2)
        .onReceive(vm.$logoutResult, perform: { result in
            switch result {
            case .success:
                self.rootIsActive = false
            case .failure(let error):
                Log.e(error)
            case .none:
                break
            }
        })
        .onLoad(perform: {
            vm.loadUserData()
        })
    }
}

struct ProfileView_Previews: PreviewProvider {
    @State static var value = true
    static var previews: some View {
        NavigationView {
            ProfileView(vm: ProfileVM(loginService: FSLoginService(service: FSServiceMock())), rootIsActive: $value)
        }
    }
}
