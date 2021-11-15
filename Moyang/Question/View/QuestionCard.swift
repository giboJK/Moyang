//
//  QuestionCard.swift
//  Moyang
//
//  Created by kibo on 2021/10/06.
//  Copyright © 2021 정김기보. All rights reserved.
//

import SwiftUI

struct QuestionCard: View {
    let questions = ["사랑한다면서 지옥에 보내는 신??",
                     "천국에서는 일을 하나요??",
                     "행복하게 살 것인가? 선하게 살 것인가?"]
    var body: some View {
        VStack {
            HStack {
                Text("생각할 거리")
                    .font(.system(size: 20, weight: .bold, design: .default))
                    .frame(width: 200, height: 40, alignment: .leading)
                Spacer()
            }
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(questions, id: \.self) { subject in
                        Text(subject)
                            .frame(width: 140, height: 50, alignment: .leading)
                            .padding(EdgeInsets(top: 0, leading: 12, bottom: 0, trailing: 12))
                            .font(.system(size: 14, weight: .regular, design: .default))
                            .background(Color(Asset.Colors.Bg.bgColorGray200.color))
                            .cornerRadius(10)
                    }
                }
                .padding(.bottom, 12)
            }.frame(height: 62)
        }
        .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
        .background(Color.white)
        .cornerRadius(20)
        .shadow(color: .gray.opacity(0.4), radius: 5, x: 3.0, y: 3)
    }
}

struct QuestionCard_Previews: PreviewProvider {
    static var previews: some View {
        QuestionCard()
            .previewLayout(.fixed(width: 414, height: 200))
    }
}
