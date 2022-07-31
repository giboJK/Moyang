//
//  AddNewGroupView.swift
//  Moyang
//
//  Created by 정김기보 on 2022/02/19.
//

import SwiftUI

struct AddNewGroupView: View {
    @StateObject var vm: AddNewGroupVM
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack(spacing: 0) {
            Text("소속 공동체")
                .foregroundColor(.nightSky1)
                .font(.system(size: 16, weight: .semibold, design: .default))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(EdgeInsets(top: 20, leading: 24, bottom: 4, trailing: 24))
        }
    }
}

struct AddNewGroupView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AddNewGroupView(vm: AddNewGroupVMMock())
        }
    }
}
