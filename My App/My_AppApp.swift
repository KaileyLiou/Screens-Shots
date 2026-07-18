//
//  My_AppApp.swift
//  My App
//
//  Created by Kailey Liou on 8/10/25.
//

import SwiftUI
import UserNotifications

// by default ios hides local notification banners while the app is open in
// the foreground (so testing with the app open and watching for it looks
// like nothing happened, even though it technically fired). this delegate
// tells ios to show the banner + play the sound even while the app is open,
// which is mainly here to make testing/demoing actually visible
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

    // no longer asking for notification permission here on launch, it now
    // happens naturally the first time a reminder actually needs to be
    // scheduled (see NotificationManager), so the user doesn't get a
    // permission popup before they've even seen the app
    var body: some Scene {
        WindowGroup {
            SplashView()
                .environmentObject(settingsStore)
                // hardcoded to light for now since dark mode's colors aren't
                // fully adaptive yet. ignoring settingsStore.appearanceMode
                // here on purpose so nothing can accidentally render broken,
                // even if someone's device is already set to system dark mode
                .preferredColorScheme(.light)
        }
    }
}
