//
//  TermsView.swift
//  Moyang
//
//  Created by kibo on 2022/02/14.
//

import SwiftUI

struct TermsView: View {
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            HStack(spacing: 0) {
                
                Button(action: {
                }, label: {
                    Text("거절")
                })
                    .buttonStyle(MoyangButtonStyle(.negative,
                                                   width: UIScreen.screenWidth / 2 - 46,
                                                   height: 50))
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 20, trailing: 10))
                
                Button(action: {
                }, label: {
                    Text("동의")
                })
                    .buttonStyle(MoyangButtonStyle(.black,
                                                   width: UIScreen.screenWidth / 2 - 46,
                                                   height: 50))
                    .padding(EdgeInsets(top: 0, leading: 10, bottom: 20, trailing: 0))
            }
        }
        .navigationTitle("이용약관")
        .frame(maxWidth: .infinity)
        .background(Color.sheep2)
    }
}

struct TermsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            TermsView()
        }
    }
}
