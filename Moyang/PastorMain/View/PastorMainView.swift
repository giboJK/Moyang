//
//  PastorMainView.swift
//  Moyang
//
//  Created by 정김기보 on 2022/01/19.
//

import SwiftUI

struct PastorMainView: View {
    @Binding var rootIsActive: Bool
    var body: some View {
        NavigationView {
            TabView {
                GroupManageView()
                    .tabItem {
                        Image(systemName: "person.3.fill")
                        Text("Group")
                    }
                    .navigationBarHidden(true)
                    .navigationBarTitleDisplayMode(.inline)
                
                ProfileView(vm: ProfileVM(), rootIsActive: $rootIsActive)
                    .tabItem {
                        Image(systemName: "person.crop.circle.fill")
                        Text("Profile")
                    }
                    .navigationBarHidden(true)
                    .navigationBarTitleDisplayMode(.inline)
            }
        }
    }
}
struct PastorMainView_Previews: PreviewProvider {
    @State static var value = true
    
    static var previews: some View {
        PastorMainView(rootIsActive: $value)
    }
}
