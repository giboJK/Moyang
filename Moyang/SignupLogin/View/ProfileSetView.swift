//
//  ProfileSetView.swift
//  Moyang
//
//  Created by kibo on 2022/02/11.
//

import SwiftUI

struct ProfileSetView: View {
    @ObservedObject var vm = ProfileSetVM(loginService: FirestoreLoginServiceImpl(service: FirestoreServiceImpl()))
    let email: String
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                Text("기본정보 입력")
                    .frame(maxWidth: .infinity, alignment: .topLeading)
                    .padding(EdgeInsets(top: 104 - UIApplication.statusBarHeight, leading: 16, bottom: 100, trailing: 0))
                    .font(.system(size: 32, weight: .bold, design: .default))
                    .foregroundColor(.nightSky1)
                
                
                TextField("", text: $vm.name)
                    .placeholder(when: vm.name.isEmpty) {
                        Text("이름").foregroundColor(.sheep4)
                    }
                    .padding()
                    .background(Color.sheep1)
                    .frame(width: UIScreen.screenWidth - 80, height: 50, alignment: .center)
                    .foregroundColor(.nightSky1)
                    .cornerRadius(8)
                    .padding(.bottom, 20)
                    .keyboardType(.emailAddress)
                DatePickerTextField(textColor: .nightSky1,
                                    placeholder: "생일",
                                    placeholderColor: .sheep4,
                                    date: $vm.birth)
                    .padding()
                    .background(Color.sheep1)
                    .frame(width: UIScreen.screenWidth - 80, height: 50, alignment: .center)
                    .foregroundColor(.nightSky1)
                    .cornerRadius(8)
                
                Spacer()
                
                Button(action: {
                    vm.setUserProfile(email: email)
                }) {
                    Text("회원가입")
                        .frame(width: UIScreen.screenWidth - 80, height: 50)
                }.buttonStyle(MoyangButtonStyle(.black,
                                                width: UIScreen.screenWidth - 80,
                                                height: 50))
                    .padding(.bottom, 20)
                    .disabled((vm.birth == nil) || (vm.name.count < 2) )
            }
            IndicatorView()
                .hidden(!vm.isAddingData)
                .frame(width: 40, height: 40, alignment: .center)
        }
        .fullScreenCover(isPresented: $vm.isAddSuccess, onDismiss: nil, content: {
            MainView(rootIsActive: $vm.isAddSuccess)
        })
        .frame(maxWidth: .infinity)
        .background(Color.sheep2)
    }
}

struct ProfileSetView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileSetView(email: "test@test.com")
    }
}
