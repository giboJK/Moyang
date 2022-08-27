//
//  LottieView.swift
//  Moyang
//
//  Created by 정김기보 on 2022/01/27.
//

import SwiftUI
import Lottie

struct LottieView: UIViewRepresentable {
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    var filename: String
    var contentMode: AnimationView.ContentMode
    var loopMode: LottieLoopMode
    var handler: (() -> Void)?
    
    var animationView = AnimationView()
    
    class Coordinator: NSObject {
        var parent: LottieView
        
        init(_ animationView: LottieView) {
            self.parent = animationView
            super.init()
        }
    }
    
    func makeUIView(context: UIViewRepresentableContext<LottieView>) -> UIView {
        let view = UIView()
        
        animationView.animation = Animation.named(filename)
        animationView.contentMode = contentMode
        animationView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(animationView)
        
        NSLayoutConstraint.activate([
            animationView.widthAnchor.constraint(equalTo: view.widthAnchor),
            animationView.heightAnchor.constraint(equalTo: view.heightAnchor)
        ])
        
        animationView.loopMode = loopMode
        animationView.play { isComplete in
            if isComplete {
                self.handler?()
            }
        }
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<LottieView>) {
        
    }
}
