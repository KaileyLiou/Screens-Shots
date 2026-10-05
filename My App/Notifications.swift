//
//  Notifications.swift
//  My App
//
//  Created by Kailey Liou on 9/20/25.
//

import Foundation
import UserNotifications

struct NotificationManager {

    static func scheduleNotification(for reminder: Reminder, hour: Int = 9, minute: Int = 0, enabled: Bool = true) {
        guard enabled else {
            print("Notifications disabled in settings; skipping schedule for \(reminder.title)")
            return
        }

        UNUserNotificationCenter.current().getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .authorized, .provisional:
                schedule(reminder, hour: hour, minute: minute)

            case .notDetermined:
                UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
                    if granted {
                        schedule(reminder, hour: hour, minute: minute)
                    } else {
                        print("Notification permission not granted")
                    }
                }

            default:
                print("Notifications not allowed")
            }
        }
    }

    private static func schedule(_ reminder: Reminder, hour: Int, minute: Int) {
        let content = UNMutableNotificationContent()
        content.title = "Screens + Shots"
        content.body = "Your \(reminder.title.lowercased()) reminder is today."
        content.sound = .default

        let calendar = Calendar.current
        var dateComponents = DateComponents()
        dateComponents.hour = hour
        dateComponents.minute = minute
        let repeats: Bool
        switch reminder.repeatInterval {
        case .none:
            dateComponents.year = calendar.component(.year, from: reminder.date)
            dateComponents.month = calendar.component(.month, from: reminder.date)
            dateComponents.day = calendar.component(.day, from: reminder.date)
            repeats = false
        case .weekly:
            dateComponents.weekday = calendar.component(.weekday, from: reminder.date)
            repeats = true
        case .monthly:
            dateComponents.day = calendar.component(.day, from: reminder.date)
            repeats = true
        case .yearly:
            dateComponents.month = calendar.component(.month, from: reminder.date)
            dateComponents.day = calendar.component(.day, from: reminder.date)
            repeats = true
        }

        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: repeats)

        let request = UNNotificationRequest(
            identifier: reminder.id.uuidString,
            content: content,
            trigger: trigger
        )

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Failed to schedule notification: \(error)")
            } else {
                print("Notification scheduled for \(reminder.title) at \(hour):\(String(format: "%02d", minute)), repeats: \(reminder.repeatInterval.rawValue)")
            }
        }
    }

    static func cancelNotification(for reminder: Reminder) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [reminder.id.uuidString])
    }
}
