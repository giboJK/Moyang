//
//  ProfileView.swift
//  Moyang
//
//  Created by kibo on 2022/01/14.
//

import SwiftUI

struct ProfileView: View {
    @ObservedObject var vm: ProfileVM

    @Binding var rootIsActive: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            Text(vm.groupInfoItem.name)
                .foregroundColor(.nightSky1)
                .font(.system(size: 18, weight: .bold, design: .default))
                .padding(.bottom, 32)
            
            
            Button(action: {
                UserData.shared.resetUserData()
                self.rootIsActive = false
            }) {
                HStack {
                    Text("로그아웃")
                        .padding(.leading, 24)
                    Spacer()
                    Image(uiImage: Asset.Images.Profile.logout.image)
                        .renderingMode(.template)
                        .foregroundColor(.white)
                        .padding(.trailing, 20)
                }
            }.buttonStyle(MoyangButtonStyle(.black,
                                            width: UIScreen.screenWidth - 80,
                                            height: 50))
                .padding(.bottom, 24)
            Spacer()
        }
        .padding(.top, 30)
        .frame(maxWidth: .infinity)
        .background(Color.sheep1)
        .onLoad {
            vm.loadUserData()
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    @State static var value = true
    static var previews: some View {
        ProfileView(vm: ProfileVM(), rootIsActive: $value)
    }
}
