//
//  MoyangApp.swift
//  Moyang
//
//  Created by 정김기보 on 2021/10/23.
//

import SwiftUI
import Swinject
import Firebase

@main
struct MoyangApp: App {
    let assembler = Assembler()
    
    init() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .sheep1
        appearance.titleTextAttributes = [.foregroundColor: UIColor.nightSky1]

        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().tintColor = .wilderness2
        
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
