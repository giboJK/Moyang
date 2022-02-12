//
//  SignUpView.swift
//  Moyang
//
//  Created by kibo on 2022/01/07.
//

import SwiftUI

struct SignUpView: View {
    @ObservedObject var vm: LoginVM
    
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
                    vm.signup()
                }) {
                    Text("회원가입")
                        .frame(width: UIScreen.screenWidth - 80, height: 50)
                }.buttonStyle(MoyangButtonStyle(.black,
                                                width: UIScreen.screenWidth - 80,
                                                height: 50))
                    .padding(.bottom, 20)
                    .disabled(!vm.id.isValidEmail || (vm.password.count < 6) )
            }
            
            IndicatorView()
                .hidden(vm.isLoadingUserDataFinished)
                .frame(width: 40, height: 40, alignment: .center)
        }
        .navigationTitle("회원가입")
        .frame(maxWidth: .infinity)
        .background(Color.sheep2)
    }
}

struct SignUpView_Previews: PreviewProvider {
    
    static var previews: some View {
        NavigationView {
            SignUpView(vm: LoginVM(loginService: FirestoreLoginServiceImpl(service: FirestoreServiceImpl())))
        }
    }
}
