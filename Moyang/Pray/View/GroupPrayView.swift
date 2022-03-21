//
//  GroupPrayView.swift
//  Moyang
//
//  Created by 정김기보 on 2022/03/16.
//

import SwiftUI

struct GroupPrayView: View {
    @StateObject var vm: GroupPrayVM
    var body: some View {
        VStack(spacing: 0) {
            Text(vm.time)
                .font(.system(size: 16, weight: .regular, design: .default))
                .foregroundColor(.sheep1)
                .padding(EdgeInsets(top: 44, leading: 0, bottom: 0, trailing: 0))
                .frame(width: .infinity, alignment: .center)
            
            Text(vm.pray)
                .font(.system(size: 17, weight: .regular, design: .default))
                .foregroundColor(.sheep1)
                .frame(width: .infinity, alignment: .topLeading)
                .padding(EdgeInsets(top: 28, leading: 40, bottom: 40, trailing: 40))
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .navigationTitle(vm.title)
        .background(
            LinearGradient(gradient: Gradient(colors: [.nightSky3, .nightSky2]), startPoint: .top, endPoint: .bottom)
        )
    }
}

struct GroupPrayView_Previews: PreviewProvider {
    static var previews: some View {
        GroupPrayView(vm: GroupPrayVMMock(title: "정김기보를 위한 기도",
                                          pray: "기도\n도도도도도\n기도도도도도도오오오오오오오 기도이오오오오오오 기도는 기도다 기도일세 기도도도돗\n\n 돗도로돗 기돗"))
    }
}
