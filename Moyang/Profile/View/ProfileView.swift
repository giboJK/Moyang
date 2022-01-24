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
        VStack {
            Text(vm.groupInfoItem.name)
                .foregroundColor(.sky1)
                .font(.system(size: 18, weight: .bold, design: .default))
                .padding(.bottom, 24)
            
            Button(action: {
                
            }) {
                HStack {
                    Text("My account")
                        .foregroundColor(.sheep1)
                        .font(Font(uiFont: .systemFont(ofSize: 18, weight: .regular)))
                    Spacer()
                    Image(systemName: "person.crop.circle")
                }
                .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
            }
            .buttonStyle(MoyangButtonStyle(.sky, width: UIScreen.screenWidth - 40, height: 52))
            
            Button(action: {
                
            }) {
                HStack {
                    Text("Help & support")
                        .foregroundColor(.sheep1)
                        .font(Font(uiFont: .systemFont(ofSize: 18, weight: .regular)))
                    Spacer()
                    Image(systemName: "questionmark.circle")
                }
                .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
            }
            .buttonStyle(MoyangButtonStyle(.sky, width: UIScreen.screenWidth - 40, height: 52))
            
            Button(action: {
                
            }) {
                HStack {
                    Text("Email us")
                        .foregroundColor(.sheep1)
                        .font(Font(uiFont: .systemFont(ofSize: 18, weight: .regular)))
                    Spacer()
                    Image(systemName: "envelope")
                }
                .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
            }
            .buttonStyle(MoyangButtonStyle(.sky, width: UIScreen.screenWidth - 40, height: 52))
            
            Button(action: {
                UserData.shared.resetUserData()
                self.rootIsActive = false
            }) {
                HStack {
                    Text("Logout")
                        .foregroundColor(.sheep1)
                        .font(Font(uiFont: .systemFont(ofSize: 18, weight: .regular)))
                    Spacer()
                    Image(uiImage: Asset.Images.Profile.logout.image)
                        .renderingMode(.template)
                        .foregroundColor(.white)
                }
                .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
            }
            .buttonStyle(MoyangButtonStyle(.sky, width: UIScreen.screenWidth - 40, height: 52))
            .padding(.top, 8)
            
            Spacer()
        }
        .padding(.top, 30)
        .frame(maxWidth: .infinity)
        .background(Color.sheep1)
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
