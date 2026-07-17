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
    var id: UUID
    var title: String
    var date: Date
    var type: String

    // true if this came from generate recommendations, false if the user
    // typed it in themselves via add reminder. lets us tell the two apart,
    // e.g. so changing your profile and regenerating only replaces the
    // automatic ones and never touches anything you added by hand
    var isGenerated: Bool

    static func ==(lhs: Reminder, rhs: Reminder) -> Bool {
        lhs.title == rhs.title && lhs.date == rhs.date && lhs.type == rhs.type
    }

    init(id: UUID = UUID(), title: String, date: Date, type: String, isGenerated: Bool = false) {
        self.id = id
        self.title = title
        self.date = date
        self.type = type
        self.isGenerated = isGenerated
    }

    enum CodingKeys: String, CodingKey {
        case id, title, date, type, isGenerated
    }

    // custom decoding so reminders already saved from before this field
    // existed don't crash or get wiped out, they just default to false
    // (treated like a manually-added reminder) since we can't know which
    // they were
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(UUID.self, forKey: .id) ?? UUID()
        title = try container.decode(String.self, forKey: .title)
        date = try container.decode(Date.self, forKey: .date)
        type = try container.decode(String.self, forKey: .type)
        isGenerated = try container.decodeIfPresent(Bool.self, forKey: .isGenerated) ?? false
    }
}
