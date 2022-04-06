//
//  SignUpView.swift
//  Moyang
//
//  Created by kibo on 2022/04/06.
//

import SwiftUI
import GoogleSignIn

struct SignUpView: View {
    var body: some View {
        VStack(spacing: 0) {
            Text("Moyang")
                .font(Font(uiFont: .systemFont(ofSize: 36, weight: .heavy)))
                .padding(.top, 120 - UIApplication.statusBarHeight)
                .foregroundColor(.nightSky1)
            
            Spacer()
            Button(action: {}) {
                NavigationLink(destination: SignUpEmailView()) {
                    Text("이메일 회원가입")
                        .frame(width: UIScreen.screenWidth - 80,
                               height: 50)
                }
            }.buttonStyle(MoyangButtonStyle(.black,
                                            width: UIScreen.screenWidth - 80,
                                            height: 48))
            .padding(.bottom, 20)
            
            GoogleSignInButton()
                .onTapGesture {
                    SocialLogin().attemptLoginGoogle { user in
                        if let user = user {
                            Log.i(user)
                        } else {
                            Log.e("No user")
                        }
                    }
                }
                .frame(width: UIScreen.screenWidth - 80, height: 52)
                .padding(EdgeInsets(top: 0, leading: 36, bottom: 32, trailing: 36))
        }
        .navigationTitle("회원가입")
        .frame(maxWidth: .infinity)
        .background(Color.sheep2)
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
