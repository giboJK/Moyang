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
        }
        .navigationTitle("설교 목록")
    }
}

struct SermonListView_Previews: PreviewProvider {
    static var previews: some View {
        SermonListView(vm: SermonListVMMock())
    }
}
