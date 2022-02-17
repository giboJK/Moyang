//
//  SermonListVMMock.swift
//  Moyang
//
//  Created by kibo on 2022/02/06.
//

import SwiftUI
import Combine

class SermonListVMMock: SermonListVM {
    
    override init() {
        super.init()
    }
    
    deinit {
        Log.i(self)
        cancellables.removeAll()
    }
    
    override func fetchSermonItem() {
        var itemList = [SermonItem]()
        let itemE = SermonItem(sermon: Sermon(title: "소속감",
                                              subtitle: "회복(5)",
                                              bible: "누가복음 6:39 - 6:49",
                                              worship: "주일청년예배",
                                              pastor: "",
                                              memberID: "",
                                              date: "2022.02.07 13:10:00",
                                              groupQuestionList: []))
        let itemA = SermonItem(sermon: Sermon(title: "한 사람",
                                              subtitle: "회복(4)",
                                              bible: "누가복음 8:26 - 8:39",
                                              worship: "주일청년예배",
                                              pastor: "",
                                              memberID: "",
                                              date: "2022.01.30 13:10:00",
                                              groupQuestionList: []))
        let itemB = SermonItem(sermon: Sermon(title: "주님의 자리",
                                              subtitle: "회복(3)",
                                              bible: "누가복음 6:39 - 6:49",
                                              worship: "주일청년예배",
                                              pastor: "",
                                              memberID: "",
                                              date: "2022.01.23 13:10:00",
                                              groupQuestionList: []))
        let itemC = SermonItem(sermon: Sermon(title: "권위",
                                              subtitle: "회복(2)",
                                              bible: "누가복음 4:31 - 4:39",
                                              worship: "주일청년예배",
                                              pastor: "",
                                              memberID: "",
                                              date: "2022.01.16 13:10:00",
                                              groupQuestionList: []))
        let itemD = SermonItem(sermon: Sermon(title: "기다림",
                                              subtitle: "회복(1)",
                                              bible: "누가복음 6:39 - 6:49",
                                              worship: "주일청년예배",
                                              pastor: "",
                                              memberID: "",
                                              date: "누가복음 2:21 - 2:40",
                                              groupQuestionList: []))
        
        itemList.append(itemE)
        itemList.append(itemA)
        itemList.append(itemB)
        itemList.append(itemC)
        itemList.append(itemD)
        
        self.itemList = itemList
    }
}
