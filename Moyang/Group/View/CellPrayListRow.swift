//
//  CellPrayListRow.swift
//  Moyang
//
//  Created by 정김기보 on 2021/12/01.
//

import SwiftUI

struct CellPrayListRow: View {
    var info: String
    var pray: String
    
    var body: some View {
        VStack {
            HStack {
                Text(info.split(separator: "_").first ?? "")
                Spacer()
            }
            HStack {
                Text(pray)
                Spacer()
            }
        }
    }
}

struct CellPrayListRow_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CellPrayListRow(info: "이름1", pray: "기도 제목1")
        }
        .previewLayout(.fixed(width: 360, height: 70))
    }
}
