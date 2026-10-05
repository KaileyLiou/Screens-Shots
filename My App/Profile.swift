//
//  Profile.swift
//  My App
//
//  Created by Kailey Liou on 10/26/25.
//

import Foundation

struct Profile: Identifiable, Codable {
    var id: UUID
    var firstName: String
    var lastName: String
    var dateOfBirth: Date
    var gender: String
    var conditions: [String]
    var familyHistory: String = ""
    var age: Int {
        let calendar = Calendar.current
        return calendar.dateComponents([.year], from: dateOfBirth, to: Date()).year ?? 0
    }

    init(id: UUID = UUID(), firstName: String, lastName: String = "", dateOfBirth: Date, gender: String, conditions: [String], familyHistory: String = "") {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.dateOfBirth = dateOfBirth
        self.gender = gender
        self.conditions = conditions
        self.familyHistory = familyHistory
    }

    enum CodingKeys: String, CodingKey {
        case id, firstName, lastName, dateOfBirth, gender, conditions, familyHistory
        case legacyName = "name"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(UUID.self, forKey: .id) ?? UUID()
        if let first = try container.decodeIfPresent(String.self, forKey: .firstName) {
            firstName = first
        } else {
            firstName = try container.decodeIfPresent(String.self, forKey: .legacyName) ?? ""
        }
        lastName = try container.decodeIfPresent(String.self, forKey: .lastName) ?? ""
        dateOfBirth = try container.decode(Date.self, forKey: .dateOfBirth)
        gender = try container.decode(String.self, forKey: .gender)
        conditions = try container.decode([String].self, forKey: .conditions)
        familyHistory = try container.decodeIfPresent(String.self, forKey: .familyHistory) ?? ""
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(firstName, forKey: .firstName)
        try container.encode(lastName, forKey: .lastName)
        try container.encode(dateOfBirth, forKey: .dateOfBirth)
        try container.encode(gender, forKey: .gender)
        try container.encode(conditions, forKey: .conditions)
        try container.encode(familyHistory, forKey: .familyHistory)
    }
}
