//
//  TestView.swift
//  Moyang
//
//  Created by kibo on 2022/03/01.
//

import SwiftUI

struct TestView: View {
    @State var isActive: Bool = false

    var body: some View {
        NavigationView {
            NavigationLink(
                destination: ContentView2(rootIsActive: self.$isActive),
                isActive: self.$isActive
            ) {
                Text("Hello, World!")
            }
            .navigationBarTitle("Root")
        }
    }
}

struct ContentView2: View {
    @Binding var rootIsActive: Bool

    var body: some View {
        NavigationLink(destination: ContentView3(shouldPopToRootView: self.$rootIsActive)) {
            Text("Hello, World #2!")
        }
        .navigationBarTitle("Two")
    }
}

struct ContentView3: View {
    @Binding var shouldPopToRootView: Bool

    var body: some View {
        VStack {
            Text("Hello, World #3!")
            Button(action: { self.shouldPopToRootView = false }) {
                Text("Pop to root")
            }
        }.navigationBarTitle("Three")
    }
}

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
    }
}
