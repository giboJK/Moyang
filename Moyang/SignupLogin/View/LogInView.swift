//
//  LogInView.swift
//  Moyang
//
//  Created by kibo on 2022/01/07.
//

import SwiftUI

struct LogInView: View {
    @ObservedObject var vm: LoginVM
    
    var body: some View {
        VStack {
            Text("Log In your eamil")
                .frame(width: UIScreen.screenWidth - 48, alignment: .leading)
                .font(.title)
                .padding(.top, 20)
                .padding(.bottom, 32)
            TextField("Email", text: $vm.id)
                .padding()
                .background(Color(UIColor.sheep200))
                .frame(width: UIScreen.screenWidth - 48, height: 52, alignment: .center)
                .cornerRadius(12.0)
                .padding(.bottom, 16)
                .keyboardType(.emailAddress)
            SecureField("Password", text: $vm.password)
                .padding()
                .background(Color(UIColor.sheep200))
                .frame(width: UIScreen.screenWidth - 48, height: 52, alignment: .center)
                .cornerRadius(12.0)
                .padding(.bottom, 24)
            Button(action: {
                vm.login()
            }, label: {
                Text("로그인")
            })
                .buttonStyle(MoyangButtonStyle(width: UIScreen.screenWidth - 48,
                                               height: 52))
            IndicatorView().hidden(!vm.isLoadingUserData)
            Spacer()
            NavigationLink(destination: MainView(), isActive: $vm.isLoginSuccess) { EmptyView() }
        }
        .background(Color(UIColor.bgColor))
    }
}

struct LogInView_Previews: PreviewProvider {
    static var previews: some View {
        LogInView(vm: LoginVM(loginService: FirestoreLoginServiceImpl()))
    }
}
