//
//  ProfileView.swift
//  Moyang
//
//  Created by kibo on 2022/01/14.
//

import SwiftUI

struct ProfileView: View {
    @Binding var rootIsActive: Bool
    var body: some View {
        VStack {
            
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
            .buttonStyle(MoyangButtonStyle(width: UIScreen.screenWidth - 40, height: 44))
            .padding(.bottom, 12)
            
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
            .buttonStyle(MoyangButtonStyle(width: UIScreen.screenWidth - 40, height: 44))
            .padding(.bottom, 12)
            
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
            .buttonStyle(MoyangButtonStyle(width: UIScreen.screenWidth - 40, height: 44))
            .padding(.bottom, 24)
            
            Button(action: {
                UserData.shared.resetUserData()
                self.rootIsActive = false
            }) {
                HStack {
                    Text("Logout")
                        .foregroundColor(.sheep1)
                        .font(Font(uiFont: .systemFont(ofSize: 18, weight: .regular)))
                    Spacer()
                    Image(systemName: "envelope")
                }
                .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
            }
            .buttonStyle(MoyangButtonStyle(width: UIScreen.screenWidth - 40, height: 44))
            
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .background(Color.sheep1)
    }
}

struct ProfileView_Previews: PreviewProvider {
    @State static var value = true
    static var previews: some View {
        ProfileView(rootIsActive: $value)
    }
}
