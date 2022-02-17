//
//  CommunityPrayCardView.swift
//  Moyang
//
//  Created by kibo on 2022/02/05.
//

import SwiftUI

struct CommunityPrayCardView: View {
    @ObservedObject var vm: CommunityPrayCardVM
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("기도")
                    .padding(.leading, 8)
                    .font(.system(size: 16, weight: .semibold, design: .default))
                    .foregroundColor(.nightSky1)
                Spacer()
                Image(systemName: "chevron.right")
            }
            .padding(.bottom, 8)
            
            VStack(spacing: 0) {
                HStack {
                    Text("내 기도")
                        .font(.system(size: 15, weight: .regular, design: .default))
                        .foregroundColor(.nightSky1)
                    Spacer()
                    Text("Last pray date:")
                        .font(.system(size: 14, weight: .regular, design: .default))
                        .foregroundColor(.sheep4)
                        .padding(.trailing, 4)
                    Text(vm.item.lastPrayDate)
                        .font(.system(size: 14, weight: .regular, design: .default))
                        .foregroundColor(.sheep4)
                }.padding(EdgeInsets(top: 16, leading: 12, bottom: 8, trailing: 12))
                Divider()
            }
        }
    }
}

struct CommunityPrayCardView_Previews: PreviewProvider {
    static var previews: some View {
        CommunityPrayCardView(vm: CommunityPrayCardVMMock())
    }
}
