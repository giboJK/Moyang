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
        NavigationView {
            TabView {
                DailyView()
                    .tabItem {
                        Image(systemName: "note.text")
                        Text("Daily")
                    }
                    .navigationBarHidden(true)
                    .navigationBarTitleDisplayMode(.inline)
                
                ProfileView(rootIsActive: $rootIsActive)
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

struct MainView_Previews: PreviewProvider {
    @State static var value = true
    static var previews: some View {
        MainView(rootIsActive: $value)
    }
}
