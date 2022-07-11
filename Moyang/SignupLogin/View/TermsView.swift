//
//  TermsView.swift
//  Moyang
//
//  Created by kibo on 2022/02/14.
//

import SwiftUI
import Swinject

struct TermsView: View {
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        TermsViewRepresentable()
            .navigationBarHidden(true)
            .edgesIgnoringSafeArea([.top, .bottom])
    }
}

struct TermsViewRepresentable: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIViewController {
        let assembly = AuthAssembly()
        let assembler = Assembler([assembly])
        let navController = UINavigationController()
        assembly.nav = navController

        if let vc = assembler.resolver.resolve(TermsVC.self) {
            navController.pushViewController(vc, animated: true)
            return navController
        } else {
            Log.e("vc init failed")
        }
        return TermsVC()
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
    }
    
    typealias UIViewControllerType = UIViewController
}
