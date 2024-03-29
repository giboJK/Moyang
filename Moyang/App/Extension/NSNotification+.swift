//
//  NSNotification+.swift
//  Moyang
//
//  Created by kibo on 2022/11/05.
//

import Foundation

extension NSNotification.Name {
    public static let ReloadPrayMainSummary: NSNotification.Name = Notification.Name("ReloadPrayMainSummary")
    public static let ReloadMyGroupSummary: NSNotification.Name = Notification.Name("ReloadMyGroupSummary")
    public static let ReloadGroupList: NSNotification.Name = Notification.Name("ReloadGroupList")
    
    // MyPrayDetailVC
    public static let MyPrayDetailVCKeyboard: NSNotification.Name = Notification.Name("MyPrayDetailVCKeyboard")
    
    // MediatorPrayMainVC
    public static let ShowNewImageBadge: NSNotification.Name = Notification.Name("ShowNewImageBadge")
    public static let HideNewImageBadge: NSNotification.Name = Notification.Name("HideNewImageBadge")
    
}
