//
//  Reminder.swift
//  My App
//
//  Created by Kailey Liou on 8/24/25.
//

import Foundation

struct Reminder: Identifiable, Codable, Equatable {
    var id = UUID()
    var title: String
    var date: Date
    var type: String
    
    static func ==(lhs: Reminder, rhs: Reminder) -> Bool {
        lhs.title == rhs.title && lhs.date == rhs.date && lhs.type == rhs.type
    }
}
