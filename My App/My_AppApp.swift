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

    // no longer asking for notification permission here on launch, it now
    // happens naturally the first time a reminder actually needs to be
    // scheduled (see NotificationManager), so the user doesn't get a
    // permission popup before they've even seen the app
    var body: some Scene {
        WindowGroup {
            SplashView()
                .environmentObject(settingsStore)
                .preferredColorScheme(settingsStore.appearanceMode.colorScheme)
        }
    }
}
