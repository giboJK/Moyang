//
//  MoyangApp.swift
//  Moyang
//
//  Created by 정김기보 on 2021/10/23.
//

import SwiftUI
import Swinject

@main
struct MoyangApp: App {
    let assembler = Assembler()
    
    init() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .bgColor
        appearance.titleTextAttributes = [.foregroundColor: Asset.Colors.Dessert.darkSand200.color]

        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().tintColor = Asset.Colors.Dessert.darkSand200.color
        
        let appAssembly = AppAssembly()
        assembler.apply(assembly: appAssembly)
    }
    
    var body: some Scene {
        WindowGroup {
            MainView()
        }
    }
}
