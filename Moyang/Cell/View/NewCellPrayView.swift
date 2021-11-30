//
//  NewCellPrayView.swift
//  Moyang
//
//  Created by 정김기보 on 2021/11/28.
//

import SwiftUI

struct NewCellPrayView: View {
    @ObservedObject var viewModel: NewCellPrayVM
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct NewCellPrayView_Previews: PreviewProvider {
    static var previews: some View {
        NewCellPrayView(viewModel: NewCellPrayVM())
    }
}
