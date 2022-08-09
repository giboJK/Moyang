//
//  SplashView.swift
//  Moyang
//
//  Created by 정김기보 on 2022/01/27.
//

import SwiftUI

struct SplashView: View {
    @State var isCompleted = false
    @State private var timeRemaining = 2
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    var body: some View {
        VStack {
//            LottieView(filename: "intro", contentMode: .scaleAspectFill, loopMode: .playOnce) {
//                isCompleted = true
//            }
            Spacer()
            HStack {
                Spacer()
                Text("하나님 저는 예배자입니다")
                    .foregroundColor(.sheep1)
                    .font(.system(size: 18))
                    .fontWeight(.regular)
                Spacer()
            }
            Spacer()
        }
        .background(
            LinearGradient(gradient: Gradient(colors: [.nightSky2, .nightSky1]), startPoint: .top, endPoint: .bottom)
        )
        .onReceive(timer) { time in
            if timeRemaining > 0 {
                timeRemaining -= 1
            } else {
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
