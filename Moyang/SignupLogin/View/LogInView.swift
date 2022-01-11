//
//  LogInView.swift
//  Moyang
//
//  Created by kibo on 2022/01/07.
//

import SwiftUI

struct LogInView: View {
    @ObservedObject var vm: LoginVM
    
    var body: some View {
        VStack {
            Text("Welcome!")
                .font(.largeTitle)
                .fontWeight(.semibold)
                .padding(.bottom, 120)
            TextField("Email", text: $vm.id)
                .padding()
                .background(Color(UIColor.sheep200))
                .frame(width: UIScreen.screenWidth - 48, height: 52, alignment: .center)
                .cornerRadius(12.0)
                .padding(.bottom, 20)
            SecureField("Password", text: $vm.password)
                .padding()
                .background(Color(UIColor.sheep200))
                .frame(width: UIScreen.screenWidth - 48, height: 52, alignment: .center)
                .cornerRadius(12.0)
                .padding(.bottom, 20)
            
            Button(action: {
                vm.login()
            }, label: {
                Text("로그인")
            })
                .frame(width: UIScreen.screenWidth - 48, height: 52, alignment: .center)
                .background(Color(UIColor.dessertStone))
                .foregroundColor(.white)
                .cornerRadius(16)
        }
        .background(Color(UIColor.bgColor))
    }
}

struct LogInView_Previews: PreviewProvider {
    static var previews: some View {
        LogInView(vm: LoginVM(loginService: FirestoreLoginServiceImpl()))
    }
}
