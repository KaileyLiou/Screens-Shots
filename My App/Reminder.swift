//
//  Reminder.swift
//  My App
//
//  Created by Kailey Liou on 8/24/25.
//

import Foundation

// a single reminder, either recommended or added by the user manually.
// equatable is written by hand (ignoring id) so two reminders count as
// the same if title/date/type match, addIfUnique in ReminderStore uses
// this to avoid duplicates
struct Reminder: Identifiable, Codable, Equatable {
    var id = UUID()
    var title: String
    var date: Date
    var type: String
    
    static func ==(lhs: Reminder, rhs: Reminder) -> Bool {
        lhs.title == rhs.title && lhs.date == rhs.date && lhs.type == rhs.type
    }
}
