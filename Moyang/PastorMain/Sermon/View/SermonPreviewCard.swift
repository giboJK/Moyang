//
//  SermonPreviewCard.swift
//  Moyang
//
//  Created by 정김기보 on 2022/02/19.
//

import SwiftUI

struct SermonPreviewCard: View {
    var item: SermonListVM.SermonItem
    var body: some View {
        VStack(spacing: 4) {
            SermonPreviewCardRow(title: "제목", content: item.title)
            SermonPreviewCardRow(title: "부제목", content: item.subtitle)
            SermonPreviewCardRow(title: "성경구절", content: item.bible)
            SermonPreviewCardRow(title: "예배", content: item.worship)
            SermonPreviewCardRow(title: "일시", content: item.date)
                .padding(.bottom, 8)
        }.padding(.top, 12)
            .background(Color.sheep1)
            .cornerRadius(12)
    }
}

struct SermonPreviewCardRow: View {
    var title: String
    var content: String
    
    var body: some View {
        HStack(spacing: 0) {
            Text(title)
                .frame(width: 56, alignment: .leading)
                .foregroundColor(.nightSky1)
                .font(.system(size: 15, weight: .regular, design: .default))
                .padding(EdgeInsets(top: 0, leading: 12, bottom: 0, trailing: 8))
            Text(content)
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundColor(.nightSky1)
                .font(.system(size: 15, weight: .regular, design: .default))
                .padding(.trailing, 8)
        }
    }
}


struct SermonPreviewCard_Previews: PreviewProvider {
    static var previews: some View {
        SermonPreviewCard(item: SermonListVM.SermonItem(sermon: Sermon(title: "소속감",
                                                                       subtitle: "회복(5)",
                                                                       bible: "누가복음 6:39 - 6:49",
                                                                       worship: "주일청년예배",
                                                                       pastor: "송요한",
                                                                       memberID: UUID().uuidString,
                                                                       date: Date().toString(format: "yyyy.MM.dd hh:mm:ss"),
                                                                       groupQuestionList: [])))
    }
}
