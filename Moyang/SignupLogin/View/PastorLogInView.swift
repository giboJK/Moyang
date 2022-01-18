//
//  PastorLogInView.swift
//  Moyang
//
//  Created by kibo on 2022/01/18.
//

import SwiftUI

struct PastorLogInView: View {
    @ObservedObject var vm: PastorLoginVM
    
    var body: some View {
        VStack {
            Text("목회자 로그인")
                .frame(width: UIScreen.screenWidth - 48, alignment: .leading)
                .font(.title)
                .padding(.top, 20)
                .padding(.bottom, 32)
            TextField("Email", text: $vm.id)
                .padding()
                .background(Color(UIColor.sheep200))
                .frame(width: UIScreen.screenWidth - 48, height: 52, alignment: .center)
                .cornerRadius(12.0)
                .padding(.bottom, 20)
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
        }
        .onAppear(perform: {
            vm.fetchPastorList()
        })
        .fullScreenCover(isPresented: $vm.isLoginSuccess, onDismiss: nil, content: {
            MainView()
        })
        .background(Color(UIColor.bgColor))
    }
}

struct PastorLoginView_Previews: PreviewProvider {
    static var previews: some View {
        PastorLogInView(vm: PastorLoginVM(loginService: FirestoreLoginServiceImpl(service: FirestoreServiceImpl())))
    }
}
