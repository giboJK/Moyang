//
//  DailySummaryVM.swift
//  Moyang
//
//  Created by 정김기보 on 2021/10/07.
//  Copyright © 2021 정김기보. All rights reserved.
//

import SwiftUI
import Combine

class DailySummaryVM: ObservableObject {
    private var disposables = Set<AnyCancellable>()
    
    @Published var items = [ListItem]()
    
    init() {
        setListItems()
    }
    
    deinit {
        Log.i(self)
        disposables.removeAll()
    }
    
    private func setListItems() {
        var calendar = Calendar.autoupdatingCurrent
        calendar.firstWeekday = 1 // Start on Sonday (or 2 for Monday)
        let today = calendar.startOfDay(for: Date())
        var listItem = [ListItem]()
        if let weekInterval = calendar.dateInterval(of: .weekOfYear, for: today) {
            for i in 0...6 {
                if let day = calendar.date(byAdding: .day, value: i, to: weekInterval.start) {
                    listItem.append(DailySummaryVM.ListItem(id: i, date: day))
                }
            }
        }
        self.items = listItem
    }
}

extension DailySummaryVM {
    struct ListItem: Identifiable {
        let id: Int
        let date: Date
        
        init(id: Int, date: Date) {
            self.id = id
            self.date = date
        }
    }
}
