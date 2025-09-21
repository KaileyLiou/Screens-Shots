//
//  Notifications.swift
//  My App
//
//  Created by Kailey Liou on 9/20/25.
//

import Foundation
import UserNotifications

struct NotificationManager {
    static func scheduleNotification(for reminder: Reminder) {
        let content = UNMutableNotificationContent()
        content.title = "SecureScreening"
        content.body = "Your \(reminder.title.lowercased()) reminder is today."
        content.sound = .default

        var dateComponents = Calendar.current.dateComponents([.year, .month, .day], from: reminder.date)
        dateComponents.hour = 9

        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)

        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: trigger
        )

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Failed to schedule notification: \(error)")
            } else {
                print("Notification scheduled for \(reminder.title) at 9 AM on \(reminder.date)")
            }
        }
    }
}
