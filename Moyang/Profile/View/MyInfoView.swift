//
//  MyInfoView.swift
//  Moyang
//
//  Created by kibo on 2022/03/14.
//

import SwiftUI

struct MyInfoView: View {
    @ObservedObject var vm: ProfileVM
    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 0) {
                Image(systemName: "person.crop.circle")
                    .font(.system(size: 64, weight: .regular))
                    .padding(EdgeInsets(top: 0, leading: 24, bottom: 0, trailing: 16))
                    .tint(.nightSky1)

            }
            VStack(spacing: 0) {
                Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)

            }
            Button(action: {}) {
                Text("회원탈퇴")
                    
            }
        }
    }
}

struct MyInfoView_Previews: PreviewProvider {
    static var previews: some View {
        MyInfoView(vm: ProfileVM())
    }
}
