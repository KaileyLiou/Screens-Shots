//
//  My_AppApp.swift
//  My App
//
//  Created by Kailey Liou on 8/10/25.
//

import SwiftUI
import UserNotifications

@main
struct My_AppApp: App {
    @StateObject private var settingsStore = SettingsStore()

    init() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("Notification permission error: \(error.localizedDescription)")
            } else {
                print("Notification permission granted: \(granted)")
            }
        }
    }

    var body: some Scene {
        WindowGroup {
            SplashView()
                .environmentObject(settingsStore)
                .preferredColorScheme(settingsStore.appearanceMode.colorScheme)
        }
    }
}
