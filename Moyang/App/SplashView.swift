//
//  SplashView.swift
//  Moyang
//
//  Created by 정김기보 on 2022/01/27.
//

import SwiftUI

struct SplashView: View {
    @State var isCompleted = false
    
    var body: some View {
        VStack {
            LottieView(filename: "intro", contentMode: .scaleAspectFill, loopMode: .playOnce) {
                isCompleted = true
            }
        }
        .fullScreenCover(isPresented: $isCompleted, onDismiss: nil, content: {
            IntroView()
        })
        .edgesIgnoringSafeArea(.all)
    }
}

struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView()
    }
}
