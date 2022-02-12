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
        ZStack {
            VStack(spacing: 0) {
                Text("Moyang")
                    .font(Font(uiFont: .systemFont(ofSize: 36, weight: .heavy)))
                    .padding(.top, 152 - UIApplication.statusBarHeight)
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
                .hidden(!vm.isLoadingUserData)
                .frame(width: 40, height: 40, alignment: .center)
        }
        .onAppear(perform: {
            vm.fetchPastorList()
        })
        .fullScreenCover(isPresented: $vm.isLoginSuccess, onDismiss: nil, content: {
            PastorMainView(rootIsActive: $vm.isLoginSuccess)
        })
        .navigationTitle("목회자 로그인")
        .frame(maxWidth: .infinity)
        .background(Color.sheep2)
    }
}

struct PastorLoginView_Previews: PreviewProvider {
    static var previews: some View {
        PastorLogInView(vm: PastorLoginVM(loginService: FirestoreLoginServiceImpl(service: FirestoreServiceImpl())))
    }
}
