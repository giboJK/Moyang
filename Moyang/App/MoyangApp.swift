//
//  MoyangApp.swift
//  Moyang
//
//  Created by 정김기보 on 2021/10/23.
//

import SwiftUI
import Swinject
import Firebase
import GoogleSignIn

@main
struct MoyangApp: App {
    let assembler = Assembler()
    
    init() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .sheep2
        appearance.titleTextAttributes = [.foregroundColor: UIColor.nightSky1]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.nightSky1]

        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().tintColor = .nightSky1
        
        let appAssembly = AppAssembly()
        assembler.apply(assembly: appAssembly)
        Log.setup()
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            SplashView()
        }
    }
}
