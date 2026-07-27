//
//  Notifications.swift
//  My App
//
//  Created by Kailey Liou on 9/20/25.
//

import Foundation
import UserNotifications

// schedules + cancels local notifications for reminders. uses the reminder's
// own uuid as the notification's request id, so a reminder always maps to
// exactly one notification and can be cancelled later just by that id
struct NotificationManager {

    // hour/minute default to 9am so old calls that don't pass a time still
    // work the same way they did before settings existed
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
                // first time a reminder is actually being created, ask now instead
                // of asking on launch before the user's even seen the app
                UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
                    if granted {
                        schedule(reminder, hour: hour, minute: minute)
                    } else {
                        print("Notification permission not granted")
                    }
                }

            default:
                // denied or restricted, nothing we can do here besides not schedule
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

        // which date parts get matched (and whether it repeats) depends on
        // the interval: leaving out year/month/day components is what makes
        // UNCalendarNotificationTrigger repeat on its own, apple handles the
        // actual recurrence once we tell it which parts to match
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

//            let trigger = UNTimeIntervalNotificationTrigger(
//                timeInterval: 5, // appears in 5 seconds for testing purposes
//                repeats: false
//            )

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

    // called when a reminder gets deleted so its notification doesn't fire
    // for something that doesn't exist anymore
    static func cancelNotification(for reminder: Reminder) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [reminder.id.uuidString])
    }
}
