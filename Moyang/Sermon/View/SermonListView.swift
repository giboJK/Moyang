//
//  SermonListView.swift
//  Moyang
//
//  Created by kibo on 2022/02/05.
//

import SwiftUI

struct SermonListView: View {
    @ObservedObject var vm: SermonListVM
    
    var body: some View {
        ZStack {
            ScrollView(.vertical, showsIndicators: true) {
                
            }
            VStack(spacing: 0) {
                Spacer()
                Button(action: {}) {
                    NavigationLink(destination: NewSermonView(vm: NewSermonVM())) {
                        Text("설교 추가")
                            .frame(width: UIScreen.screenWidth - 80,
                                   height: 50)
                    }
                }.buttonStyle(MoyangButtonStyle(width: UIScreen.screenWidth - 80,
                                                height: 50))
                .padding(.bottom, 10)
            }
        }
        .navigationTitle("설교 목록")
        .frame(maxWidth: .infinity)
        .background(Color.sheep2)
    }
}

struct SermonListView_Previews: PreviewProvider {
    static var previews: some View {
        SermonListView(vm: SermonListVMMock())
    }
}
