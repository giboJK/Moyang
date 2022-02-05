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
        NavigationView {
            TabView {
                PastorComunityView()
                    .tabItem {
                        Image(systemName: "person.3.fill")
                        Text("공동체")
                    }
                    .navigationBarHidden(true)
                    .navigationBarTitleDisplayMode(.inline)
                
                ProfileView(vm: ProfileVM(), rootIsActive: $rootIsActive)
                    .tabItem {
                        Image(systemName: "person.crop.circle.fill")
                        Text("내 정보")
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
