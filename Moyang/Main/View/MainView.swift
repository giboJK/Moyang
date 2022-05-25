//
//  MainView.swift
//  Moyang
//
//  Created by 정김기보 on 2021/10/23.
//

import SwiftUI

struct MainView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject var vm = MainVM()
    
    var body: some View {
        NavigationView {
            MainViewRepresentable()
                .navigationBarHidden(true)
                .accentColor(.ydGreen1)
                .edgesIgnoringSafeArea([.top])
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
                Log.e("🔴🔴🔴 Logout Error")
            }
        })
        .navigationViewStyle(.columns)
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
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
