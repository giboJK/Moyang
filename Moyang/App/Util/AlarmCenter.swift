//
//  AlarmCenter.swift
//  Moyang
//
//  Created by 정김기보 on 2022/04/28.
//

import Foundation
import UserNotifications

class AlarmCenter {
    
    static let shared = AlarmCenter()
    
    let identifier = "MOYANG_NOTIFICATION_SCAN"
    
    let title = "모여라 양들아"
    let bodyPray = "기도할 시간이에요."
    let bodyQT = "묵상할 시간이에요."
    
    let moyangPRAYNotiKey = "MOYANG_NOTI_PRAY"
    let moyangQTNotiKey = "MOYANG_NOTI_QT"
    
    func setNotification(type: AlarmType, time: String, day: String) {
        let timeComponents = time.components(separatedBy: ":")
        if timeComponents.count < 2 { Log.e("Time isn't set correctly"); return }
        
        let hour = timeComponents[0]
        let min = timeComponents[1]
        
        var dateComponents = DateComponents()
        dateComponents.hour = Int(hour)
        dateComponents.minute = Int(min)
        var dayInt = [Int]()
        day.forEach { c in
            if let intVal = c.wholeNumberValue {
                dayInt.append(intVal + 1)
            }
        }
        for i in dayInt {
            dateComponents.weekday = i
            
            let content = UNMutableNotificationContent()
            content.title = title
            var identifier = ""
            if type == .pray {
                content.body = bodyPray
                identifier = moyangPRAYNotiKey + "\(i)"
            } else if type == .qt {
                content.body = bodyQT
                identifier = moyangQTNotiKey + "\(i)"
            }
            content.sound = .default
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
            
            let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
            let center = UNUserNotificationCenter.current()
            center.add(request, withCompletionHandler: { (error) in
                if error != nil {
                    // Handle the error
                }
            })
        }
    }
    
    func removeAllNotification() {
        UNUserNotificationCenter.current().getPendingNotificationRequests { (requests) in
            Log.d(requests)
        }
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
    
    func removeNotification(type: AlarmType) {
        var ids = [String]()
        if type == .pray {
            for i in 1...7 {
                ids.append(moyangPRAYNotiKey + "\(i)")
            }
        } else {
            for i in 1...7 {
                ids.append(moyangQTNotiKey + "\(i)")
            }
        }
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ids)
    }
}

enum AlarmType: String {
    case pray = "PRAY"
    case qt = "QT"
    case rookie = "Rookie"
    case junior = "Junior"
    case advanced = "Advanced"
}
