//
//  PastorComunityView.swift
//  Moyang
//
//  Created by 정김기보 on 2022/01/23.
//

import SwiftUI

struct PastorComunityView: View {
    //    @State var isSermonList = false
    
    var body: some View {
        VStack(spacing: 40) {
            Button(action: {}) {
                NavigationLink(destination: SermonListView(vm: SermonListVM())) {
                    Text("설교 목록")
                        .frame(width: UIScreen.screenWidth - 80,
                               height: 50)
                }
            }.buttonStyle(MoyangButtonStyle(width: UIScreen.screenWidth - 80,
                                            height: 50))
            
            Button(action: {}) {
                NavigationLink(destination: SermonListView(vm: SermonListVM())) {
                    Text("공동체 그룹")
                        .frame(width: UIScreen.screenWidth - 80,
                               height: 50)
                }
            }.buttonStyle(MoyangButtonStyle(width: UIScreen.screenWidth - 80,
                                            height: 50))
            
            Button(action: {}) {
                NavigationLink(destination: SermonListView(vm: SermonListVM())) {
                    Text("공동체 기도 목록")
                        .frame(width: UIScreen.screenWidth - 80,
                               height: 50)
                }
            }.buttonStyle(MoyangButtonStyle(width: UIScreen.screenWidth - 80,
                                            height: 50))
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 120)
        .background(Color.sheep2)
    }
}

struct PastorComunityView_Previews: PreviewProvider {
    static var previews: some View {
        PastorComunityView()
    }
}
