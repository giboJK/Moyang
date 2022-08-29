//
//  MoyangApp.swift
//  Moyang
//
//  Created by 정김기보 on 2021/10/23.
//

import SwiftUI
import Swinject
import Firebase
import FirebaseMessaging
import GoogleSignIn

@main
struct MoyangApp: App {
    let assembler = Assembler()
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    init() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .nightSky1
        appearance.titleTextAttributes = [.foregroundColor: UIColor.sheep2]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.sheep2]

        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().tintColor = .sheep2
        
        let appAssembly = AppAssembly()
        assembler.apply(assembly: appAssembly)
        Log.setup()
    }
    
    var body: some Scene {
        WindowGroup {
            SplashView()
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    
    // 앱이 켜졌을때
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        // Use Firebase library to configure APIs
        // 파이어베이스 설정
        FirebaseApp.configure()
        
        // 원격 알림 등록
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: { _, _ in }
            )
        } else {
            let settings: UIUserNotificationSettings =
            UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        // 메세징 델리겟
        Messaging.messaging().delegate = self
        
        application.registerForRemoteNotifications()
        
        // 푸시 포그라운드 설정
        UNUserNotificationCenter.current().delegate = self
        
        return true
    }
    
    // fcm 토큰이 등록 되었을 때
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        Log.i("[Log] deviceToken :", deviceTokenString)
        Messaging.messaging().apnsToken = deviceToken
    }
    
}

extension AppDelegate : MessagingDelegate {
    
    // fcm 등록 토큰을 받았을 때
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        Log.d("Firebase registration token: \(String(describing: fcmToken))")
    }
    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
        Log.d(messaging)
    }
}

extension AppDelegate : UNUserNotificationCenterDelegate {
    
    // 푸시메세지가 앱이 켜져 있을때 나올때
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        let userInfo = notification.request.content.userInfo
        
        print("willPresent: userInfo: ", userInfo)
        
        completionHandler([.banner, .sound, .badge])
    }
    
    // 푸시메세지를 받았을 때
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        print("didReceive: userInfo: ", userInfo)
        completionHandler()
    }
}
