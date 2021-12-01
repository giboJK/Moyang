//
//  CellMemberPrayEditView.swift
//  Moyang
//
//  Created by 정김기보 on 2021/12/01.
//

import SwiftUI

struct CellMemberPrayEditView: View {
    var name: String
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
        Text(name)
    }
}

struct CellMemberPrayEditView_Previews: PreviewProvider {
    static var previews: some View {
        CellMemberPrayEditView(name: "Test")
    }
}
