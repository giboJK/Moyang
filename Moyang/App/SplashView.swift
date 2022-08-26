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
    @State private var timeRemaining = 0.8
    
    let randomInt = Int.random(in: 0..<4)
    let middle = ["저는", "오늘도", "영원히", "제 삶을"]
    let last = ["예배자입니다", "감사합니다", "사랑합니다", "드립니다"]
    
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
                Text(middle[randomInt])
                    .foregroundColor(.sheep1)
                    .font(.system(size: 20))
                    .fontWeight(.regular)
                    .opacity(move ? 1 : 0.5)
                    .offset(y: move ? 0 : 6)
                    .animation(Animation.easeIn(duration: 0.5), value: move)
                Spacer()
            }
            .padding(.bottom, 4)
            HStack(spacing: 0) {
                Spacer()
                    .frame(width: 120)
                Text(last[randomInt])
                    .foregroundColor(.sheep1)
                    .font(.system(size: 26))
                    .fontWeight(.regular)
                    .opacity(move ? 1 : 0.3)
                    .offset(y: move ? 0 : 8)
                    .animation(Animation.easeIn(duration: 0.5), value: move)
                Spacer()
            }
            Spacer()
        }
        .background(
//            LinearGradient(gradient: Gradient(colors: [.nightSky2, .nightSky1]), startPoint: .top, endPoint: .bottom)
            Color(uiColor: .nightSky1)
        )
        .onReceive(timer) { _ in
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
        .onAppear {
            UIView.setAnimationsEnabled(false)
        }
    }
}

struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView()
    }
}
