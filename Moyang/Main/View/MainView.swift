//
//  MainView.swift
//  Moyang
//
//  Created by 정김기보 on 2021/10/23.
//

import SwiftUI

struct MainView: View {
    @Binding var rootIsActive: Bool
    
    var body: some View {
        TabView {
            NavigationView {
                CommunityMainView()
                    .navigationBarHidden(true)
                    .navigationBarTitleDisplayMode(.inline)
            }
            .tabItem {
                Image(systemName: "note.text")
                Text("일용할 양식")
            }
            
            NavigationView {
                ProfileView(vm: ProfileVM(), rootIsActive: $rootIsActive)
                    .navigationBarHidden(true)
                    .navigationBarTitleDisplayMode(.inline)
            }
            .tabItem {
                Image(systemName: "person.crop.circle.fill")
                Text("Profile")
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    @State static var value = true
    static var previews: some View {
        MainView(rootIsActive: $value)
    }
}
