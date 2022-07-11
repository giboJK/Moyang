//
//  IntroView.swift
//  Moyang
//
//  Created by kibo on 2022/01/11.
//

import SwiftUI
import Swinject

struct IntroView: View {
    @State private var isTermsPresented = false
    
    var body: some View {
        IntroViewRepresentable()
            .edgesIgnoringSafeArea([.top, .bottom])
    }
}

struct IntroViewRepresentable: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIViewController {
        let assembly = IntroAssembly()
        let assembler = Assembler([assembly])
        let nav = UINavigationController()
        assembly.nav = nav
        if let coordinator = assembler.resolver.resolve(IntroCoordinator.self) {
            coordinator.start(true, completion: nil)
            return nav
        } else {
            Log.e("Init failed")
        }
        return IntroVC()
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
    }
    
    typealias UIViewControllerType = UIViewController
}
