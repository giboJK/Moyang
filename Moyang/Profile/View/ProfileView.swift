//
//  ProfileView.swift
//  Moyang
//
//  Created by kibo on 2022/01/14.
//

import SwiftUI

struct ProfileView: View {
    @Binding var rootIsActive: Bool
    var body: some View {
        VStack {
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            Button("Logout") {
                UserData.shared.resetUserData()
                self.rootIsActive = false
            }
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    @State static var value = true
    static var previews: some View {
        ProfileView(rootIsActive: $value)
    }
}
