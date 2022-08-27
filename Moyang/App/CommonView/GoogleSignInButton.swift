//
//  GoogleSignInButton.swift
//  Moyang
//
//  Created by kibo on 2022/04/06.
//

import SwiftUI
import GoogleSignIn

struct GoogleSignInButton: UIViewRepresentable {
    @Environment(\.colorScheme) var colorScheme
    
    func makeUIView(context: Context) -> GIDSignInButton {
        return GIDSignInButton()
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
    }
}
