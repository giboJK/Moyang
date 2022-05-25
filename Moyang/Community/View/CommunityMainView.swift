//
//  CommunityMainView.swift
//  Moyang
//
//  Created by kibo on 2022/01/14.
//

import SwiftUI

struct CommunityMainView: View {
    var body: some View {
        return ZStack {
            Color.sheep1.ignoresSafeArea()
            VStack(spacing: 0) {
                CommunityCardList(vm: CommunityCardListVM())
                    .padding(.top, 28)
            }
        }
        .navigationBarHidden(true)
    }
}

struct CommunityMainView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            CommunityMainView()
        }
        .navigationBarHidden(true)
    }
}
