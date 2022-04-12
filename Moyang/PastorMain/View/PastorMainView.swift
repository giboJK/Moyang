//
//  PastorMainView.swift
//  Moyang
//
//  Created by 정김기보 on 2022/01/19.
//

import SwiftUI

struct PastorMainView: View {
    @ObservedObject var vm = PastorMainVM()
    
    @Binding var rootIsActive: Bool
    var body: some View {
        TabView {
            NavigationView {
                PastorComunityView()
                    .navigationBarHidden(true)
                    .navigationBarTitleDisplayMode(.inline)
            }
            .tabItem {
                Image(systemName: "person.3.fill")
                Text("공동체")
            }
            
            NavigationView {
                ProfileView(vm: ProfileVM(loginService: FSLoginService(service: FSServiceImpl())),
                            rootIsActive: $rootIsActive)
                    .navigationBarHidden(true)
                    .navigationBarTitleDisplayMode(.inline)
            }
            .tabItem {
                Image(systemName: "person.crop.circle.fill")
                Text("Profile")
            }
        }
        .accentColor(.ydGreen1)
    }
}
struct PastorMainView_Previews: PreviewProvider {
    @State static var value = true
    
    static var previews: some View {
        PastorMainView(rootIsActive: $value)
    }
}
