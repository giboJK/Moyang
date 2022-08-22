//
//  Calendar+.swift
//  Moyang
//
//  Created by 정김기보 on 2022/07/27.
//

import Foundation

extension Calendar {
    private var currentDate: Date { return Date() }
    
    func isDateInThisWeek(_ date: Date) -> Bool {
        return isDate(date, equalTo: currentDate, toGranularity: .weekOfYear)
    }
    
    func isDateInThisMonth(_ date: Date) -> Bool {
        return isDate(date, equalTo: currentDate, toGranularity: .month)
    }
    
    func isDateInNextWeek(_ date: Date) -> Bool {
        guard let nextWeek = self.date(byAdding: DateComponents(weekOfYear: 1), to: currentDate) else {
            return false
        }
        return isDate(date, equalTo: nextWeek, toGranularity: .weekOfYear)
    }
    
    func isDateInNextMonth(_ date: Date) -> Bool {
        guard let nextMonth = self.date(byAdding: DateComponents(month: 1), to: currentDate) else {
            return false
        }
        return isDate(date, equalTo: nextMonth, toGranularity: .month)
    }
    
    func isDateInFollowingMonth(_ date: Date) -> Bool {
        guard let followingMonth = self.date(byAdding: DateComponents(month: 2), to: currentDate) else {
            return false
        }
        return isDate(date, equalTo: followingMonth, toGranularity: .month)
    }
    // Number of days pass midnight, including a start date
    func numberOfDaysBetween(_ from: Date, and to: Date) -> Int {
        let fromDate = startOfDay(for: from)
        let toDate = startOfDay(for: to)
        let numberOfDays = dateComponents([.day], from: fromDate, to: toDate)
        
        return numberOfDays.day! + 1 // <1>
    }
}
