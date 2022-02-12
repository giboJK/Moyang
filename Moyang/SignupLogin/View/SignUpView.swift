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
        VStack {
            Text("Create account with your eamil")
                .frame(width: UIScreen.screenWidth - 48, alignment: .leading)
                .font(.title)
                .padding(.top, 20)
                .padding(.bottom, 32)
                .foregroundColor(.nightSky1)
            TextField("Email", text: $vm.id)
                .padding()
                .background(Color.sheep2)
                .frame(width: UIScreen.screenWidth - 48, height: 52, alignment: .center)
                .cornerRadius(12.0)
                .padding(.bottom, 16)
                .keyboardType(.emailAddress)
            SecureField("Password", text: $vm.password)
                .padding()
                .background(Color.sheep2)
                .frame(width: UIScreen.screenWidth - 48, height: 52, alignment: .center)
                .cornerRadius(12.0)
                .padding(.bottom, 24)
            Button(action: {
                vm.signup()
            }, label: {
                Text("회원가입")
            })
                .buttonStyle(MoyangButtonStyle(.black,
                                               width: UIScreen.screenWidth - 48,
                                               height: 52))
                .padding(.bottom, 24)
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .background(Color.sheep1)
    }
}

struct SignUpView_Previews: PreviewProvider {
    
    static var previews: some View {
        SignUpView(vm: LoginVM(loginService: FirestoreLoginServiceImpl(service: FirestoreServiceImpl())))
    }
}
