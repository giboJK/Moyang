//
//  PrayPreviewCard.swift
//  Moyang
//
//  Created by 정김기보 on 2021/09/30.
//  Copyright © 2021 정김기보. All rights reserved.
//

import SwiftUI

struct PrayPreviewCard: View {
    @ObservedObject var vm: PrayCardVM

    var body: some View {
        VStack {
            HStack {
                Text("나의 기도")
                    .font(.system(size: 16, weight: .bold, design: .default))
                Spacer()
                Image(systemName: "arrow.forward")
            }
            .padding(.top, 10)
            Divider().padding(-5)
            HStack {
                Text(vm.pray.praySubject)
                    .font(.system(size: 16, weight: .regular, design: .default))
                    .frame(maxWidth: .infinity, alignment: .topLeading)
                Spacer()
            }
            Spacer()
            HStack {
                Text("다음 기도 시간")
                    .font(.system(size: 14, weight: .regular, design: .default))
                    .frame(maxWidth: .infinity, alignment: .topLeading)
                Spacer()
                Text(vm.pray.prayAlarmTime)
                    .font(.system(size: 14, weight: .regular, design: .default))
            }
            .padding(.bottom, 10)
        }
        .modifier(MainCard())
        .eraseToAnyView()
    }
}
