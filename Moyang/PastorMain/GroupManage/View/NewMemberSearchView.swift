//
//  NewMemberSearchView.swift
//  Moyang
//
//  Created by 정김기보 on 2022/02/20.
//

import SwiftUI

struct NewMemberSearchView: View {
    var isLeaderSelectionMode: Bool
    @StateObject var vm: AddNewGroupVM
    
    @State private var searchText = ""
    
    var body: some View {
        VStack(spacing: 0) {
            Divider()
                .padding(.bottom, 4)
                .foregroundColor(.sheep4)
        }
    }
}

struct NewMemberSearchView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            NewMemberSearchView(isLeaderSelectionMode: true, vm: AddNewGroupVMMock())
        }
    }
}
