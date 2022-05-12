//
//  MainView.swift
//  Moyang
//
//  Created by 정김기보 on 2021/10/23.
//

import SwiftUI

struct MainView: View {
    @Binding var rootIsActive: Bool
    
    @Environment(\.horizontalSizeClass) var sizeClass
    
    var body: some View {
        NavigationView {
            TabView {
                CommunityMainView()
                    .navigationBarHidden(true)
                    .navigationBarTitleDisplayMode(.inline)
                    .tabItem {
                        Image(uiImage: Asset.Images.Tabbar.cross.image)
                        Text("공동체")
                    }
                
                ProfileView(vm: ProfileVM(loginService: FSLoginService(service: FSServiceImpl())),
                            rootIsActive: $rootIsActive)
                .navigationBarHidden(true)
                .navigationBarTitleDisplayMode(.inline)
                .tabItem {
                    Image(systemName: "person.crop.circle.fill")
                    Text("Profile")
                }
            }
            .accentColor(.ydGreen1)
        }
    }
}

struct MainView_Previews: PreviewProvider {
    @State static var value = true
    static var previews: some View {
        MainView(rootIsActive: $value)
    }
}
