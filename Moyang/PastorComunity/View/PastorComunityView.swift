//
//  PastorComunityView.swift
//  Moyang
//
//  Created by 정김기보 on 2022/01/23.
//

import SwiftUI

struct PastorComunityView: View {
    var body: some View {
        VStack(spacing: 40) {
            Button(action: {}) {
                NavigationLink(destination: SermonListView()) {
                    Text("설교 목록")
                }
            }
            .buttonStyle(MoyangButtonStyle(width: UIScreen.screenWidth - 80,
                                           height: 50))
            
            Button(action: {}) {
                NavigationLink(destination: SermonListView()) {
                    Text("공동체 그룹 관리")
                }
            }
            .buttonStyle(MoyangButtonStyle(width: UIScreen.screenWidth - 80,
                                           height: 50))
            
            Button(action: {}) {
                NavigationLink(destination: SermonListView()) {
                    Text("공동체 기도 목록")
                }
            }
            .buttonStyle(MoyangButtonStyle(width: UIScreen.screenWidth - 80,
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
