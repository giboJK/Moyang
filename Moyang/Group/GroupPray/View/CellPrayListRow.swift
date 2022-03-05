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
                    .font(.system(size: 16, weight: .regular, design: .default))
                    .foregroundColor(.nightSky1)
                Spacer()
            }
            HStack {
                Text(pray)
                    .font(.system(size: 16, weight: .regular, design: .default))
                    .foregroundColor(.nightSky1)
                Spacer()
            }
        }
        .background(Color.sheep1)
    }
}

struct CellPrayListRow_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CellPrayListRow(info: "이름1", pray: "기도 제목1")
        }
    }
}
