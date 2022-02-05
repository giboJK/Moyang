//
//  CommunityGroupCardView.swift
//  Moyang
//
//  Created by kibo on 2022/02/05.
//

import SwiftUI

struct CommunityGroupCardView: View {
    @ObservedObject var vm: CommunityGroupCardVM
    
    var body: some View {
        VStack {
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
        }
        .modifier(MainCard())
        .eraseToAnyView()
    }
}

struct CommunityGroupCardView_Previews: PreviewProvider {
    static var previews: some View {
        CommunityGroupCardView(vm: CommunityGroupCardVMMock())
    }
}
