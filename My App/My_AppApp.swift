//
//  My_AppApp.swift
//  My App
//
//  Created by Kailey Liou on 8/10/25.
//

import SwiftUI
import UserNotifications

class NotificationDelegate: NSObject, UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound, .list])
    }
}

@main
struct My_AppApp: App {
    @StateObject private var settingsStore = SettingsStore()
    private let notificationDelegate = NotificationDelegate()

    init() {
        UNUserNotificationCenter.current().delegate = notificationDelegate
    }

    var body: some Scene {
        WindowGroup {
            SplashView()
                .environmentObject(settingsStore)
                .preferredColorScheme(.light)
        }
    }
}
