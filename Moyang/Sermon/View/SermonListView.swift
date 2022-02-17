//
//  SermonListView.swift
//  Moyang
//
//  Created by 정김기보 on 2022/02/16.
//

import SwiftUI

struct SermonListView: View {
    @ObservedObject var vm: SermonListVM
    
    var body: some View {
        ZStack {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 0) {
                    ForEach(vm.itemList.indices, id: \.self) { i in
                        
                        
                        
                        
                    }
                }
            }
            
            VStack(spacing: 0) {
                Spacer()
                Button(action: {
                    
                }) {
                    Image(systemName: "plus")
                }
                .buttonStyle(MoyangButtonStyle(.black,
                                               width: 80,
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
        NavigationView {
            SermonListView(vm: SermonListVMMock())
//        SermonListView()
        }
    }
}
