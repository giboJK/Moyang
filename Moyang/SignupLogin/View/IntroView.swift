//
//  IntroView.swift
//  Moyang
//
//  Created by kibo on 2022/01/11.
//

import SwiftUI

struct IntroView: View {
    @StateObject var vm: IntroVM
    @State private var isTermsPresented = false
    
    var body: some View {
        IntroViewRepresentable()
    }
}

struct IntroViewRepresentable: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIViewController {
        return IntroVC()
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
    }
    
    typealias UIViewControllerType = UIViewController
}
