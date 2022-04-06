//
//  SignUpView.swift
//  Moyang
//
//  Created by kibo on 2022/04/06.
//

import SwiftUI
import GoogleSignIn
import Firebase

struct SignUpView: View {
    @StateObject var vm = SignUpVM()
    
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
                    vm.signIn()
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


class SignUpVM: ObservableObject {
    enum SignInState {
        case signedIn
        case signedOut
    }
    
    @Published var state: SignInState = .signedOut
    
    func signIn() {
        // 1
        if GIDSignIn.sharedInstance.hasPreviousSignIn() {
            GIDSignIn.sharedInstance.restorePreviousSignIn { [unowned self] user, error in
                authenticateUser(for: user, with: error)
            }
        } else {
            guard let clientID = FirebaseApp.app()?.options.clientID else { return }
            
            let configuration = GIDConfiguration(clientID: clientID)
            
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
            guard let rootViewController = windowScene.windows.first?.rootViewController else { return }
            
            GIDSignIn.sharedInstance.signIn(with: configuration, presenting: rootViewController) { [unowned self] user, error in
                authenticateUser(for: user, with: error)
            }
        }
    }
    private func authenticateUser(for user: GIDGoogleUser?, with error: Error?) {
        // 1
        if let error = error {
            Log.e(error.localizedDescription)
            return
        }
        
        // 2
        guard let authentication = user?.authentication, let idToken = authentication.idToken else { return }
        
        let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: authentication.accessToken)
        
        // 3
        Auth.auth().signIn(with: credential) { [unowned self] (_, error) in
            if let error = error {
                Log.e(error.localizedDescription)
            } else {
                self.state = .signedIn
            }
        }
    }
    
    func signOut() {
        GIDSignIn.sharedInstance.signOut()
        
        do {
            try Auth.auth().signOut()
            
            state = .signedOut
        } catch {
            Log.e(error.localizedDescription)
        }
    }
}
