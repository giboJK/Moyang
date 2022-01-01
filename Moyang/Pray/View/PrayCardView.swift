//
//  PrayCardView.swift
//  Moyang
//
//  Created by 정김기보 on 2021/12/25.
//

import SwiftUI

struct PrayCardView: View {
    @ObservedObject var vm: PrayCardVM
    
    @State private var editPraySubject = false
    
    var body: some View {
        VStack {
            HStack {
                Text("나의 기도")
                    .font(.system(size: 16, weight: .bold, design: .default))
                Spacer()
                Button {
                    editPraySubject.toggle()
                } label: {
                    Image(systemName: "pencil")
                }
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
                Image(systemName: "clock")
                Text(vm.pray.prayTime)
                    .frame(maxWidth: .infinity, alignment: .topLeading)
                Spacer()
                Text("다음 기도 시간")
                    .font(.system(size: 14, weight: .regular, design: .default))
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

struct PrayCardView_Previews: PreviewProvider {
    static let praySubject = DummyData().praySubject
    static var previews: some View {
        PrayCardView(vm: PrayCardVM(pray: praySubject))
            .previewLayout(.fixed(width: 414, height: 250))
    }
}
