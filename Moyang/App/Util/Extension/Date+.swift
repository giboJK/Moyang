//
//  Date+.swift
//  Moyang
//
//  Created by 정김기보 on 2021/10/23.
//

import Foundation

extension Date {
    var startOfDay: Date {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(secondsFromGMT: 0)!
        return calendar.startOfDay(for: self)
    }
    
    var endOfDay: Date {
        let cal = Calendar.current
        var components = DateComponents()
        components.day = 1
        return cal.date(byAdding: components, to: self.startOfDay)!.addingTimeInterval(-1)
    }

    func stringToDate(dateString: String) -> Date {
        let dateFormatter = DateFormatter()

        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?

        guard let date = dateFormatter.date(from: dateString) else {
            return Date()
        }

        return date
    }

    func getDate(dayDifference: Int) -> Date {
        var components = DateComponents()
        components.day = dayDifference
        return Calendar.current.date(byAdding: components, to: startOfDay)!
    }

    func toString(format: String) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = format
        return formatter.string(from: self as Date)
    }

    func toString(_ format: String = "yyyy.MM.dd") -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }

    func weekDayString() -> String {
        let dayList = ["일", "월", "화", "수", "목", "금", "토"]
        let weekday = Calendar.current.component(.weekday, from: self)
        return dayList[weekday - 1]
    }
    
    func weekDayNumber() -> Int {
        return Calendar.current.dateComponents([.weekday], from: self).weekday ?? 1
    }
    
    static func weekDayString(no: Int) -> String {
        let dayList = ["", "일", "월", "화", "수", "목", "금", "토"]
        return dayList[no]
    }
    
    func get(_ components: Calendar.Component..., calendar: Calendar = Calendar.current) -> DateComponents {
        return calendar.dateComponents(Set(components), from: self)
    }
    
    func get(_ component: Calendar.Component, calendar: Calendar = Calendar.current) -> Int {
        return calendar.component(component, from: self)
    }
    
    func interval(ofComponent comp: Calendar.Component, fromDate date: Date) -> Int {
        
        let currentCalendar = Calendar.current
        
        guard let start = currentCalendar.ordinality(of: comp, in: .era, for: date) else { return 0 }
        guard let end = currentCalendar.ordinality(of: comp, in: .era, for: self) else { return 0 }
        
        return end - start
    }
    
    func convertTodayString(format: String = "yyyy. MM. dd.") -> String {
        let interval = self.interval(ofComponent: .day, fromDate: Date())
        switch interval {
        case 0:
            return "오늘"
        case 1:
            return "내일"
        case -1:
            return "어제"
//        case Int.min ..< (-1):
//            return "\(interval * -1)일 전"
//        default:
//            return "\(interval)일 후"
        default:
            return self.toString(format)
        }
    }
    
    static func countOfWeekDay(from startDate: Date, to endDate: Date, weekDay: Int) -> Int {
        if weekDay == 0 { return 0 }
        let interval = endDate.interval(ofComponent: .day, fromDate: startDate) + 1
        if interval < 0 { return 0 }
        var count = 0
        var currentWeekDay = startDate.weekDayNumber()
        for _ in 0 ..< interval {
            if currentWeekDay == weekDay {
                count += 1
            }
            currentWeekDay = (currentWeekDay % 7) + 1
        }
        
        return count
    }
}

extension Date {
    var firstDayOfWeek: Date {
        var beginningOfWeek = Date()
        var interval = TimeInterval()
        
        _ = Calendar.current.dateInterval(of: .weekOfYear, start: &beginningOfWeek, interval: &interval, for: self)
        return beginningOfWeek
    }
    
    func addWeeks(_ numWeeks: Int) -> Date {
        var components = DateComponents()
        components.weekOfYear = numWeeks
        
        return Calendar.current.date(byAdding: components, to: self)!
    }
    
    func weeksAgo(_ numWeeks: Int) -> Date {
        return addWeeks(-numWeeks)
    }
    
    func addDays(_ numDays: Int) -> Date {
        var components = DateComponents()
        components.day = numDays
        
        return Calendar.current.date(byAdding: components, to: self)!
    }
    
    func daysAgo(_ numDays: Int) -> Date {
        return addDays(-numDays)
    }
    
    func addHours(_ numHours: Int) -> Date {
        var components = DateComponents()
        components.hour = numHours
        
        return Calendar.current.date(byAdding: components, to: self)!
    }
    
    func hoursAgo(_ numHours: Int) -> Date {
        return addHours(-numHours)
    }
    
    func addMinutes(_ numMinutes: Double) -> Date {
        return self.addingTimeInterval(60 * numMinutes)
    }
    
    func minutesAgo(_ numMinutes: Double) -> Date {
        return addMinutes(-numMinutes)
    }
}
