//
//  AlarmCenter.swift
//  Moyang
//
//  Created by 정김기보 on 2022/04/28.
//

import Foundation
import UserNotifications

class ReminderCenter {
    
    static let shared = ReminderCenter()
    
    let identifier = "MOYANG_NOTIFICATION_SCAN"
    
    let title = "모여라 양들아"
    let body = "기도할 시간이에요. 하나님과 대화를 나누어 볼까요?"
    
    let dateKey = "MOYANG_NOTI_DATE"
    var date: Date {
        get {
            return (UserDefaults.standard.object(forKey: dateKey) as? Date) ?? Date(year: 2019, month: 1, day: 1, hour: 21, minute: 0)
        }
        set(v) {
            UserDefaults.standard.set(v, forKey: dateKey)
        }
    }
    
    func addNoti(components: DateComponents) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        
        let weekOfMonth = components.weekOfMonth!
        let weekDay = components.weekday!
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        let request = UNNotificationRequest(identifier: "\(self.identifier)\(weekOfMonth)/\(weekDay)", content: content, trigger: trigger)
        
        let center = UNUserNotificationCenter.current()
        center.add(request) { _ in
        }
    }
    // 한 주 중 2일에 한 번 짝수날
    func addNotiEven2days(components: DateComponents, weekOfMonth: Int) {
        var dateComponents = components
        dateComponents.weekOfMonth = weekOfMonth
        
        dateComponents.weekday = 2
        addNoti(components: dateComponents)
        
        dateComponents.weekday = 4
        addNoti(components: dateComponents)
        
        dateComponents.weekday = 6
        addNoti(components: dateComponents)
    }
    
    // 한 주 중 2일에 한 번 홀수날
    func addNotiOdd2Days(components: DateComponents, weekOfMonth: Int) {
        var dateComponents = components
        dateComponents.weekOfMonth = weekOfMonth
        
        dateComponents.weekday = 1
        addNoti(components: dateComponents)
        
        dateComponents.weekday = 3
        addNoti(components: dateComponents)
        
        dateComponents.weekday = 5
        addNoti(components: dateComponents)
    }
    
    func addNoti3Days147(components: DateComponents, weekOfMonth: Int) {
        var dateComponents = components
        dateComponents.weekOfMonth = weekOfMonth
        
        dateComponents.weekday = 1
        addNoti(components: dateComponents)
        
        dateComponents.weekday = 4
        addNoti(components: dateComponents)
    }
    
    func addNoti3Days36(components: DateComponents, weekOfMonth: Int) {
        var dateComponents = components
        dateComponents.weekOfMonth = weekOfMonth
        
        dateComponents.weekday = 3
        addNoti(components: dateComponents)
        
        dateComponents.weekday = 6
        addNoti(components: dateComponents)
    }
    
    func addNoti3Days25(components: DateComponents, weekOfMonth: Int) {
        var dateComponents = components
        dateComponents.weekOfMonth = weekOfMonth
        
        dateComponents.weekday = 2
        addNoti(components: dateComponents)
        
        dateComponents.weekday = 5
        addNoti(components: dateComponents)
    }
    
    func setNotification(type: AlarmType, time: String, ampm: String) {
        var fixedTime = ""
        let timeComponents = time.components(separatedBy: ":")
        var hourString = ""
        let minString = timeComponents[1]
        if ampm == "PM" {
            if var hourInt = Int(timeComponents[0]) {
                hourInt += 12
                hourString = "\(hourInt)"
            } else {
                Log.e("Time Error")
                return
            }
        } else {
            hourString = timeComponents[0]
        }
        fixedTime = hourString + ":" + minString
        setNotification(type: type, time: fixedTime)
    }
    func setNotification(type: AlarmType, time: String) {
        removeNotification()
        Log.d("setNotification - \(type.rawValue), \(time)")
        DispatchQueue.main.async {
            let timeComponents = time.components(separatedBy: ":")
            if timeComponents.count < 2 { Log.e("Time isn't set correctly"); return }
            
            let weekOfMonthSet = [1, 2, 3, 4, 5, 6]
            let timeHour = timeComponents[0]
            let timeMinute = timeComponents[1]
            
            var dateComponents = DateComponents()
            dateComponents.hour = Int(timeHour)
            dateComponents.minute = Int(timeMinute)
            
            let content = UNMutableNotificationContent()
            content.title = self.title
            content.body = self.body
            content.sound = .default
            
            if type == .rookie {
            } else if type == .junior {
            } else if type == .advanced {
                for i in weekOfMonthSet {
                    dateComponents.weekOfMonth = i
                    dateComponents.weekday = 1
                    self.addNoti(components: dateComponents)
                    
                    dateComponents.weekday = 2
                    self.addNoti(components: dateComponents)
                    
                    dateComponents.weekday = 3
                    self.addNoti(components: dateComponents)
                    
                    dateComponents.weekday = 4
                    self.addNoti(components: dateComponents)
                    
                    dateComponents.weekday = 5
                    self.addNoti(components: dateComponents)
                    
                    dateComponents.weekday = 6
                    self.addNoti(components: dateComponents)
                    
                    dateComponents.weekday = 7
                    self.addNoti(components: dateComponents)
                }
            }
        }
    }
    
    func removeNotification() {
        UNUserNotificationCenter.current().getPendingNotificationRequests { (requests) in
            Log.d(requests)
        }
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
}


enum AlarmType: String {
    case rookie = "Rookie"
    case junior = "Junior"
    case advanced = "Advanced"
}
