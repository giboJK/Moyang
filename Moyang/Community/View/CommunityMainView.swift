//
//  CommunityMainView.swift
//  Moyang
//
//  Created by kibo on 2022/01/14.
//

import SwiftUI

struct CommunityMainView: View {
    var body: some View {
        ZStack {
            Color.sheep1.ignoresSafeArea()
            VStack(spacing: 0) {
                SermonCardView()
                CommunityCardList()
                
            }
            .background(Color.sheep1)
        }
    }
}

struct CommunityMainView_Previews: PreviewProvider {
    static var previews: some View {
        CommunityMainView()
    }
}
