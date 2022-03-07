//
//  ProfileView.swift
//  Moyang
//
//  Created by kibo on 2022/01/14.
//

import SwiftUI

struct ProfileView: View {
    @ObservedObject var vm: ProfileVM

    @Binding var rootIsActive: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                Text(vm.groupInfoItem.name + "님,\n안녕하세요")
                    .foregroundColor(.nightSky1)
                    .font(.system(size: 18, weight: .bold, design: .default))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 28)
            }
            .padding(.bottom, 8)
            Text(vm.levelDesc)
                .foregroundColor(.ydGreen1)
                .font(.system(size: 16, weight: .regular, design: .default))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 28)
                .padding(.bottom, 28)
            
            VStack(spacing: 0) {
                Button(action: {
    //                UserData.shared.resetUserData()
    //                self.rootIsActive = false
                }) {
                    Text("내 정보")
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
                    Text("기도 시간")
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
                    UserData.shared.resetUserData()
                    self.rootIsActive = false
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
        .onLoad {
            vm.loadUserData()
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    @State static var value = true
    static var previews: some View {
        ProfileView(vm: ProfileVM(), rootIsActive: $value)
    }
}
