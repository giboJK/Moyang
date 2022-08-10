//
//  SplashView.swift
//  Moyang
//
//  Created by 정김기보 on 2022/01/27.
//

import SwiftUI

struct SplashView: View {
    @State var isCompleted = false
    @State var move = false
    @State private var timeRemaining = 1.4
    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    var body: some View {
        VStack(spacing: 0) {
//            LottieView(filename: "intro", contentMode: .scaleAspectFill, loopMode: .playOnce) {
//                isCompleted = true
//            }
            Spacer()
            HStack(spacing: 0) {
                Spacer()
                    .frame(width: 120)
                Text("하나님")
                    .foregroundColor(.sheep1)
                    .font(.system(size: 36))
                    .fontWeight(.bold)
                Spacer()
            }
            .padding(.bottom, 12)
            HStack(spacing: 0) {
                Spacer()
                    .frame(width: 120)
                Text("제 삶이")
                    .foregroundColor(.sheep1)
                    .font(.system(size: 20))
                    .fontWeight(.regular)
                    .opacity(move ? 1 : 0.4)
                    .offset(y: move ? 0 : 16)
                    .animation(Animation.easeIn(duration: 1.0), value: move)
                Spacer()
            }
            .padding(.bottom, 4)
            HStack(spacing: 0) {
                Spacer()
                    .frame(width: 120)
                Text("예배입니다")
                    .foregroundColor(.sheep1)
                    .font(.system(size: 26))
                    .fontWeight(.regular)
                    .opacity(move ? 1 : 0.2)
                    .offset(y: move ? 0 : 28)
                    .animation(Animation.easeIn(duration: 1.0), value: move)
                Spacer()
            }
            Spacer()
        }
        .background(
            LinearGradient(gradient: Gradient(colors: [.nightSky2, .nightSky1]), startPoint: .top, endPoint: .bottom)
        )
        .onReceive(timer) { time in
            if timeRemaining > 0 {
                timeRemaining -= 0.1
                move = true
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
