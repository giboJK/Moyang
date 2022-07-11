//
//  MainView.swift
//  Moyang
//
//  Created by 정김기보 on 2021/10/23.
//

import SwiftUI
import Swinject

struct MainView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject var vm = MainVM()
    
    var body: some View {
        NavigationView {
            MainViewRepresentable()
                .navigationBarHidden(true)
                .accentColor(.ydGreen1)
                .edgesIgnoringSafeArea([.top, .bottom])
        }
        .preferredColorScheme(.light)
        .onReceive(vm.$logoutResult, perform: { result in
            switch result {
            case .success(let isSuccess):
                if isSuccess {
                    Log.e("🔵🔵🔵🔵🔵🔵🔵🔵🔵🔵🔵 - User Logout - 🔵🔵🔵🔵🔵🔵🔵🔵🔵🔵🔵")
                    dismiss()
                } else {
                    Log.e("🔴🔴🔴 Logout Error")
                }
            default:
                break
            }
        })
        .navigationViewStyle(.columns)
    }
}

struct MainViewRepresentable: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIViewController {
        let mainAssembly = MainAssembly()
        let communityMainAssembly = CommunityMainAssembly()
        let assembler = Assembler([mainAssembly, communityMainAssembly])
        let navController = UINavigationController()
        mainAssembly.nav = navController
        communityMainAssembly.nav = navController

        if let vc = assembler.resolver.resolve(MainVC.self) {
            navController.pushViewController(vc, animated: true)
            return navController
        } else {
            Log.e("vc init failed")
        }
        return MainVC()
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
    }
    
    typealias UIViewControllerType = UIViewController
}
