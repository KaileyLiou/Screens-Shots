//
//  AppSettings.swift
//  My App
//
//  Created by Kailey Liou on 7/15/26.
//

import Foundation
import SwiftUI

enum AppearanceMode: String, CaseIterable, Identifiable, Codable {
    case system = "System"
    case light = "Light"
    case dark = "Dark"

    var id: String { rawValue }

    var colorScheme: ColorScheme? {
        switch self {
        case .system: return nil
        case .light: return .light
        case .dark: return .dark
        }
    }
}

class SettingsStore: ObservableObject {
    @Published var notificationHour: Int {
        didSet { UserDefaults.standard.set(notificationHour, forKey: "notification_hour") }
    }
    @Published var notificationMinute: Int {
        didSet { UserDefaults.standard.set(notificationMinute, forKey: "notification_minute") }
    }
    @Published var notificationsEnabled: Bool {
        didSet { UserDefaults.standard.set(notificationsEnabled, forKey: "notifications_enabled") }
    }
    @Published var appearanceMode: AppearanceMode {
        didSet { UserDefaults.standard.set(appearanceMode.rawValue, forKey: "appearance_mode") }
    }

    var notificationTime: Date {
        get {
            Calendar.current.date(bySettingHour: notificationHour, minute: notificationMinute, second: 0, of: Date()) ?? Date()
        }
        set {
            let comps = Calendar.current.dateComponents([.hour, .minute], from: newValue)
            notificationHour = comps.hour ?? 9
            notificationMinute = comps.minute ?? 0
        }
    }

    init() {
        let defaults = UserDefaults.standard
        self.notificationHour = (defaults.object(forKey: "notification_hour") as? Int) ?? 9
        self.notificationMinute = (defaults.object(forKey: "notification_minute") as? Int) ?? 0
        self.notificationsEnabled = (defaults.object(forKey: "notifications_enabled") as? Bool) ?? true
        if let raw = defaults.string(forKey: "appearance_mode"), let mode = AppearanceMode(rawValue: raw) {
            self.appearanceMode = mode
        } else {
            self.appearanceMode = .system
        }
    }
}
