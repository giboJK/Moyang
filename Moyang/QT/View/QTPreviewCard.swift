//
//  QTPreviewCard.swift
//  Moyang
//
//  Created by 정김기보 on 2021/10/09.
//  Copyright © 2021 정김기보. All rights reserved.
//

import SwiftUI

struct QTPreviewCard: View {
    let qtTitles = ["살인과 낙태", "살인과 마음", "6계명을 지킬 수 있나?", "간음", "하나님이 바라보시는 간음"]
    
    var body: some View {
        VStack {
            HStack {
                Text("연동 QT")
                    .font(.system(size: 20, weight: .bold, design: .default))
                    .frame(width: 200, height: 40, alignment: .leading)
                Spacer()
            }
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(qtTitles, id: \.self) { title in
                        Text(title)
                            .frame(width: 80, height: 60, alignment: .center)
                            .font(.system(size: 14, weight: .regular, design: .default))
                            .foregroundColor(Color.white)
                            .background(Color(Asset.desertStone.color))
                            .cornerRadius(10)
                    }
                }
            }.frame(height: 80)
        }
        .padding(EdgeInsets(top: 0, leading: 20, bottom: 2, trailing: 20))
        .background(Color.white)
        .cornerRadius(20)
        .shadow(color: .gray.opacity(0.4), radius: 5, x: 3.0, y: 3)
    }
}

struct QTPreviewCard_Previews: PreviewProvider {
    static var previews: some View {
        QTPreviewCard()
    }
}
