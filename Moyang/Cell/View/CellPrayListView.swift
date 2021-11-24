//
//  CellPrayListView.swift
//  Moyang
//
//  Created by 정김기보 on 2021/11/21.
//

import SwiftUI

struct CellPrayListView: View {
    @ObservedObject var viewModel: CellPrayListVM
    
    var body: some View {
        List(viewModel.items, id: \.name) { item in
            VStack {
                HStack {
                    Text(item.name)
                    Spacer()
                }
                HStack {
                    Text(item.pray)
                    Spacer()
                }
            }.onTapGesture {
                Log.d("\(item.name)")
                viewModel.open(item)
            }
        }
    }
}

struct CellPrayListView_Previews: PreviewProvider {
    static var previews: some View {
        CellPrayListView(viewModel: CellPrayListVM(coordinator: CellCoordinator()))
    }
}
