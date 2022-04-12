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
            ZStack {
                VStack(spacing: 0) {
                    Text("Moyang")
                        .font(Font(uiFont: .systemFont(ofSize: 36, weight: .heavy)))
                        .padding(.top, 128 - UIApplication.statusBarHeight)
                        .foregroundColor(.nightSky1)
                    
                    Spacer()
                    Button(action: {}) {
                        NavigationLink(destination: PrivacyPolicyView()) {
                            Text("회원가입")
                                .frame(width: UIScreen.screenWidth - 80, height: 50)
                        }
                    }
                    .buttonStyle(MoyangButtonStyle(.black,
                                                   width: UIScreen.screenWidth - 80,
                                                   height: 50))
                    .padding(.bottom, 20)
                    
                    Button(action: {}) {
                        let loginVM = LoginVM()
                        NavigationLink(destination: LogInView(vm: loginVM)) {
                            Text("로그인")
                        }
                    }
                    .buttonStyle(MoyangButtonStyle(.ghost, width: UIScreen.screenWidth - 80,
                                                   height: 50))
                    .padding(.bottom, 20)
                    
                    Button(action: {}) {
                        let loginVM = PastorLoginVM(loginService: FSLoginService(service: FSServiceImpl()))
                        NavigationLink(destination: PastorLogInView(vm: loginVM)) {
                            Text("목회자 로그인")
                        }
                    }
                    .buttonStyle(MoyangButtonStyle(.ghost, width: UIScreen.screenWidth - 80,
                                                   height: 50))
                    .padding(.bottom, 20)
                }
                
                IndicatorView()
                    .hidden(!vm.isLoadingUserData)
                    .frame(width: 40, height: 40, alignment: .center)
            }
            .fullScreenCover(isPresented: $vm.isLoginSuccess, onDismiss: nil, content: {
                if UserData.shared.isPastor ?? false {
                    PastorMainView(rootIsActive: $vm.isLoginSuccess)
                } else {
                    MainView(rootIsActive: $vm.isLoginSuccess)
                }
            })
            .frame(maxWidth: .infinity)
            .background(Color.sheep2)
        }
    }
}

struct IntroView_Previews: PreviewProvider {
    static var previews: some View {
        IntroView(vm: IntroVM(loginService: FSLoginService(service: FSServiceMock())))
    }
}
