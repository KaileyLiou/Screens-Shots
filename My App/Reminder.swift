//
//  Reminder.swift
//  My App
//
//  Created by Kailey Liou on 8/24/25.
//

import Foundation

enum RepeatInterval: String, Codable, CaseIterable, Identifiable {
    case none = "Never"
    case weekly = "Weekly"
    case monthly = "Monthly"
    case yearly = "Yearly"

    var id: String { rawValue }
}

struct Reminder: Identifiable, Codable, Equatable {
    var id: UUID
    var title: String
    var date: Date
    var type: String
    var isGenerated: Bool
    var repeatInterval: RepeatInterval

    static func ==(lhs: Reminder, rhs: Reminder) -> Bool {
        lhs.title == rhs.title && lhs.date == rhs.date && lhs.type == rhs.type
    }

    init(id: UUID = UUID(), title: String, date: Date, type: String, isGenerated: Bool = false, repeatInterval: RepeatInterval = .none) {
        self.id = id
        self.title = title
        self.date = date
        self.type = type
        self.isGenerated = isGenerated
        self.repeatInterval = repeatInterval
    }

    enum CodingKeys: String, CodingKey {
        case id, title, date, type, isGenerated, repeatInterval
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(UUID.self, forKey: .id) ?? UUID()
        title = try container.decode(String.self, forKey: .title)
        date = try container.decode(Date.self, forKey: .date)
        type = try container.decode(String.self, forKey: .type)
        isGenerated = try container.decodeIfPresent(Bool.self, forKey: .isGenerated) ?? false
        repeatInterval = try container.decodeIfPresent(RepeatInterval.self, forKey: .repeatInterval) ?? .none
    }
}
