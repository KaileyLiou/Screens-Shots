//
//  Reminder.swift
//  My App
//
//  Created by Kailey Liou on 8/24/25.
//

import Foundation

struct Reminder: Identifiable {
    let id = UUID()
    var title: String
    var date: Date
    var type: String
}
