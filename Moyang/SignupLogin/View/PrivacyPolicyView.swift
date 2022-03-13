//
//  PrivacyPolicyView.swift
//  Moyang
//
//  Created by 정김기보 on 2022/03/13.
//

import SwiftUI
import WebKit

struct PrivacyPolicyView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(spacing: 0) {
            WebView(url: URL(string: "https://tistory3.daumcdn.net/tistory/3831166/skin/images/moyang%20privacy%20policy.html")!)
                .padding(EdgeInsets(top: 20, leading: 20, bottom: 16, trailing: 20))
            
            HStack(spacing: 0) {
                Button(action: {
                    dismiss()
                }, label: {
                    Text("거절")
                })
                    .buttonStyle(MoyangButtonStyle(.negative,
                                                   width: (UIScreen.screenWidth - 80) / 2,
                                                   height: 50))
                    .padding(.trailing, 20)
                
                Button(action: {}) {
                    let loginVM = LoginVM()
                    NavigationLink(destination: SignUpView(vm: loginVM)) {
                        Text("동의")
                            .frame(width: UIScreen.screenWidth - 80, height: 50)
                    }
                }
                .buttonStyle(MoyangButtonStyle(.black,
                                               width: (UIScreen.screenWidth - 80) / 2,
                                               height: 50))
            }
            .padding(.bottom, 20)
        }
        .navigationTitle("이용약관")
        .frame(maxWidth: .infinity)
        .background(Color.sheep2)
    }
}

struct PrivacyPolicyView_Previews: PreviewProvider {
    static var previews: some View {
        PrivacyPolicyView()
    }
}
