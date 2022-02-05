//
//  CommunityMainView.swift
//  Moyang
//
//  Created by kibo on 2022/01/14.
//

import SwiftUI

struct CommunityMainView: View {
    @ObservedObject var vm = CommunityMainVM()
    
    var body: some View {
        ZStack {
            Color.sheep1.ignoresSafeArea()
            VStack(spacing: 0) {
                SermonCardView()
                CommunityCardList(vm: vm.communityCardListVM,
                                  communityGroupCardVM: vm.communityGroupCardVM)
                
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
