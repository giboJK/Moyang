//
//  GoogleSignInButton.swift
//  Moyang
//
//  Created by kibo on 2022/04/06.
//

import SwiftUI
import GoogleSignIn

// Button
struct GoogleSignInButton: UIViewRepresentable {
    func makeUIView(context: Context) -> GIDSignInButton {
        return GIDSignInButton()
    }
    
    func updateUIView(_ uiView: GIDSignInButton, context: Context) {
    }
}

// Sign-In flow UI of the provider
struct SocialLogin: UIViewRepresentable {
    func makeUIView(context: UIViewRepresentableContext<SocialLogin>) -> UIView {
        return UIView()
    }
    
    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<SocialLogin>) {
    }
    
    func attemptLoginGoogle(handler: @escaping (GIDGoogleUser?) -> Void) {
        if let vc = UIApplication.shared.windows.last?.rootViewController {
            GIDSignIn.sharedInstance.signIn(with: NetConst.signInConfig, presenting: vc) { user, error in
                if let error = error {
                    Log.e("")
                } else {
                    handler(user)
                }
            }
        }
    }
    
    func signOutGoogleAccount() {
        GIDSignIn.sharedInstance.signOut()
    }
}
