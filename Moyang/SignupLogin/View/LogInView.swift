//
//  LogInView.swift
//  Moyang
//
//  Created by kibo on 2022/01/07.
//

import SwiftUI

struct LogInView: View {
    @ObservedObject var vm: LoginVM
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    var body: some View {
        VStack {
            Text("Log In your eamil")
                .font(.largeTitle)
                .fontWeight(.semibold)
                .padding(.top, 100)
                .padding(.bottom, 32)
            TextField("Email", text: $vm.id)
                .padding()
                .background(Color(UIColor.sheep200))
                .frame(width: UIScreen.screenWidth - 48, height: 52, alignment: .center)
                .cornerRadius(12.0)
                .padding(.bottom, 16)
            SecureField("Password", text: $vm.password)
                .padding()
                .background(Color(UIColor.sheep200))
                .frame(width: UIScreen.screenWidth - 48, height: 52, alignment: .center)
                .cornerRadius(12.0)
                .padding(.bottom, 24)
            Button(action: {
                vm.signup()
            }, label: {
                Text("회원가입")
            })
                .buttonStyle(MoyangButtonStyle(width: UIScreen.screenWidth - 48,
                                               height: 52))
            Spacer()
        }
        .navigationBarItems(trailing: Button(action: { self.mode.wrappedValue.dismiss()},
                                             label: {
            Image(systemName: "")
                .foregroundColor(Color.black)
        }))
        .background(Color(UIColor.bgColor))
    }
}

struct LogInView_Previews: PreviewProvider {
    static var previews: some View {
        LogInView(vm: LoginVM(loginService: FirestoreLoginServiceImpl()))
    }
}
