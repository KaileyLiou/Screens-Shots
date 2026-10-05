//
//  ReminderStore.swift
//  My App
//
//  Created by Kailey Liou on 9/20/25.
//

import Foundation

class ReminderStore: ObservableObject {
    @Published var reminders: [Reminder] = [] {
        didSet { saveReminders() }
    }
    
    private let remindersKey = "reminders_key"
    
    init() { loadReminders() }
    
    func addIfUnique(_ newReminder: Reminder) {
        guard !reminders.contains(where: { $0.title == newReminder.title && $0.date == newReminder.date }) else { return }
        reminders.append(newReminder)
    }
    
    private func saveReminders() {
        if let encoded = try? JSONEncoder().encode(reminders) {
            UserDefaults.standard.set(encoded, forKey: remindersKey)
        }
    }
    
    private func loadReminders() {
        if let data = UserDefaults.standard.data(forKey: remindersKey),
           let decoded = try? JSONDecoder().decode([Reminder].self, from: data) {
            reminders = decoded
        }
    }
}
