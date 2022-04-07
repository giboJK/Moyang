//
//  LogInView.swift
//  Moyang
//
//  Created by kibo on 2022/01/07.
//

import SwiftUI

struct LogInView: View {
    @ObservedObject var vm: LoginVM
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                Text("Moyang")
                    .font(Font(uiFont: .systemFont(ofSize: 36, weight: .heavy)))
                    .padding(.top, 120 - UIApplication.statusBarHeight)
                    .foregroundColor(.nightSky1)
                
                Spacer()
                TextField("", text: $vm.id)
                    .placeholder(when: vm.id.isEmpty) {
                        Text("Email").foregroundColor(.sheep4)
                    }
                    .padding()
                    .background(Color.sheep1)
                    .frame(width: UIScreen.screenWidth - 80, height: 50, alignment: .center)
                    .foregroundColor(.nightSky1)
                    .cornerRadius(8)
                    .padding(.bottom, 20)
                    .keyboardType(.emailAddress)
                
                SecureField("", text: $vm.password)
                    .placeholder(when: vm.password.isEmpty) {
                        Text("Password").foregroundColor(.sheep4)
                    }
                    .padding()
                    .background(Color.sheep1)
                    .frame(width: UIScreen.screenWidth - 80, height: 50, alignment: .center)
                    .foregroundColor(.nightSky1)
                    .cornerRadius(8)
                    .padding(.bottom, 32)
                
                Button(action: {
                    vm.login()
                }, label: {
                    Text("로그인")
                })
                    .buttonStyle(MoyangButtonStyle(.black,
                                                   width: UIScreen.screenWidth - 80,
                                                   height: 50))
                    .padding(.bottom, 20)
                    .disabled(!vm.id.isValidEmail || (vm.password.count < 6))
                
                GoogleSignInButton()
                    .onTapGesture {
                        vm.googleSignIn()
                    }
                    .frame(width: UIScreen.screenWidth - 80, height: 52)
                    .padding(EdgeInsets(top: 0, leading: 36, bottom: 20, trailing: 36))
                
                Button(action: {
                    vm.findPassword()
                }, label: {
                    HStack {
                        Spacer()
                        Text("비밀번호 찾기")
                            .foregroundColor(.nightSky1)
                            .font(Font(uiFont: .systemFont(ofSize: 16, weight: .bold)))
                            .padding(.trailing, 40)
                    }
                })
                    .padding(.bottom, 20)
            }
            
            IndicatorView()
                .hidden(vm.isLoadingUserDataFinished)
                .frame(width: 40, height: 40, alignment: .center)
            
            NavigationLink(
                destination: ProfileSetView(email: vm.id),
                isActive: $vm.moveToProfileSetView
            ) {
                EmptyView()
            }
        }
        .fullScreenCover(isPresented: $vm.isLoginSuccess, onDismiss: self.didDismiss, content: {
            MainView(rootIsActive: $vm.isLoginSuccess)
        })
        .navigationTitle("로그인")
        .frame(maxWidth: .infinity)
        .background(Color.sheep2)
        .alert(isPresented: $vm.showInvalidPWPopUp, content: { () -> Alert in
            Alert(title: Text(vm.errorTitle),
                  message: Text(vm.errorMessage),
                  dismissButton: .default(Text("확인")))
                })
    }
    
    func didDismiss() {
        dismiss()
    }
}

struct LogInView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            LogInView(vm: LoginVM())
        }
    }
}
