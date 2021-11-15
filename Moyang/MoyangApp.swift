//
//  MoyangApp.swift
//  Moyang
//
//  Created by 정김기보 on 2021/10/23.
//

import SwiftUI

@main
struct MoyangApp: App {
    init() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = Asset.Colors.Bg.bgColor.color
        appearance.titleTextAttributes = [.foregroundColor: Asset.Colors.Dessert.darkSand200.color]

        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().tintColor = Asset.Colors.Dessert.darkSand200.color
    }
    
    var body: some Scene {
        WindowGroup {
            MainView()
        }
    }
}
