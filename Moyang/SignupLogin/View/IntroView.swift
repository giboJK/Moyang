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
            VStack(spacing: 0) {
                Text("Moyang")
                    .font(Font(uiFont: .systemFont(ofSize: 32, weight: .heavy)))
                    .padding(.top, 160)
                    .foregroundColor(.nightSky1)
                
                Spacer()
                Button(action: {}) {
                    let loginVM = LoginVM(loginService: FirestoreLoginServiceImpl(service: FirestoreServiceImpl()))
                    NavigationLink(destination: SignUpView(vm: loginVM)) {
                        Text("회원가입")
                    }
                }
                .buttonStyle(MoyangButtonStyle(width: UIScreen.screenWidth - 48,
                                               height: 52))
                .padding(.bottom, 16)
                
                Button(action: {}) {
                    let loginVM = LoginVM(loginService: FirestoreLoginServiceImpl(service: FirestoreServiceImpl()))
                    NavigationLink(destination: LogInView(vm: loginVM)) {
                        Text("로그인")
                    }
                }
                .buttonStyle(MoyangButtonStyle(.ghost, width: UIScreen.screenWidth - 48,
                                               height: 52))
                .padding(.bottom, 16)
                
                Button(action: {}) {
                    let loginVM = PastorLoginVM(loginService: FirestoreLoginServiceImpl(service: FirestoreServiceImpl()))
                    NavigationLink(destination: PastorLogInView(vm: loginVM)) {
                        Text("목회자 로그인")
                    }
                }
                .buttonStyle(MoyangButtonStyle(.ghost, width: UIScreen.screenWidth - 48,
                                               height: 52))
                .padding(.bottom, 12)
            }
            .onAppear {
                vm.tryAutoLogin()
            }
            .fullScreenCover(isPresented: $vm.isLoginSuccess, onDismiss: nil, content: {
                MainView(rootIsActive: $vm.isLoginSuccess)
            })
            .frame(maxWidth: .infinity)
            .background(Color.sheep1)
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
