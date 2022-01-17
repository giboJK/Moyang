//
//  IntroView.swift
//  Moyang
//
//  Created by kibo on 2022/01/11.
//

import SwiftUI

struct IntroView: View {
    @ObservedObject var vm: IntroVM
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Moyang")
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                    .padding(.top, 240)
                
                Spacer()
                Button(action: {}) {
                    let loginVM = LoginVM(loginService: FirestoreLoginServiceImpl(service: FirestoreServiceImpl()))
                    NavigationLink(destination: SignUpView(vm: loginVM)) {
                        Text("회원가입")
                    }
                }
                .buttonStyle(MoyangButtonStyle(width: UIScreen.screenWidth - 48,
                                               height: 52))
                .padding(.bottom, 24)
                
                Button(action: {}) {
                    let loginVM = LoginVM(loginService: FirestoreLoginServiceImpl(service: FirestoreServiceImpl()))
                    NavigationLink(destination: LogInView(vm: loginVM)) {
                        Text("로그인")
                    }
                }
                .buttonStyle(MoyangButtonStyle(.ghost, width: UIScreen.screenWidth - 48,
                                               height: 52))
                .padding(.bottom, 24)
                
            }
            .onAppear {
                vm.tryAutoLogin()
            }
            .fullScreenCover(isPresented: $vm.isLoginSuccess, onDismiss: nil, content: {
                MainView()
            })
            .background(Color(UIColor.bgColor))
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarHidden(true)
        }
    }
}

struct IntroView_Previews: PreviewProvider {
    static var previews: some View {
        IntroView(vm: IntroVM(loginService: FirestoreLoginServiceImpl(service: FirestoreServiceImpl())))
    }
}
