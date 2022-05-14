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
//            TabView(selection: $currentTab) {
//                CommunityMainView()
//                    .navigationBarHidden(true)
//                    .tabItem {
//                        Image(uiImage: Asset.Images.Tabbar.cross.image)
//                        Text("공동체")
//                    }
//
//                ProfileView(vm: ProfileVM(loginService: FSLoginService(service: FSServiceImpl())),
//                            rootIsActive: $rootIsActive)
//                .navigationBarHidden(true)
//                .tabItem {
//                    Image(systemName: "person.crop.circle.fill")
//                    Text("Profile")
//                }
//            }
            MainViewRepresentable()
                .navigationBarHidden(true)
                .accentColor(.ydGreen1)
        }
        .navigationViewStyle(.columns)
    }
}

struct MainView_Previews: PreviewProvider {
    @State static var value = true
    static var previews: some View {
        MainView(rootIsActive: $value)
    }
}

struct MainViewRepresentable: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> MainVC {
        let vc = MainVC()
        return vc
    }
    
    func updateUIViewController(_ uiViewController: MainVC, context: Context) {
    }
    
    typealias UIViewControllerType = MainVC
}
