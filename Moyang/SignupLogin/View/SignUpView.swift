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
            Text("Moyang")
                .font(.largeTitle)
                .fontWeight(.semibold)
                .padding(.bottom, 120)
            TextField("Email", text: $vm.id)
                .padding()
                .background(Color(UIColor.sheep200))
                .frame(width: UIScreen.screenWidth - 48, height: 52, alignment: .center)
                .cornerRadius(12.0)
                .padding(.bottom, 20)
            SecureField("Password", text: $vm.password)
                .padding()
                .background(Color(UIColor.sheep200))
                .frame(width: UIScreen.screenWidth - 48, height: 52, alignment: .center)
                .cornerRadius(12.0)
                .padding(.bottom, 20)
            
            Button(action: {
                vm.signup()
            }, label: {
                Text("회원가입")
            })
                .buttonStyle(MoyangButtonStyle(width: UIScreen.screenWidth - 48,
                                               height: 52))
        }
        .background(Color(UIColor.bgColor))
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView(vm: LoginVM(loginService: FirestoreLoginServiceImpl()))
    }
}
