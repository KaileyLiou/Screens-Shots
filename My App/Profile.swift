//
//  Profile.swift
//  My App
//
//  Created by Kailey Liou on 10/26/25.
//

import Foundation

// the user's health profile, this is what the recommendation engine reads
// to figure out which vaccines/screenings apply to them
struct Profile: Identifiable, Codable {
    var id: UUID
    var firstName: String
    var lastName: String
    var dateOfBirth: Date
    var gender: String
    var conditions: [String]
    var familyHistory: String = ""

    // computed instead of stored so it stays correct even if the app is
    // open across the user's birthday
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
        case legacyName = "name" // the old single-field name, kept only for migrating old saved profiles
    }

    // profiles saved before the first/last name split only have "name", not
    // "firstName"/"lastName". this decodes the old field into firstName so
    // existing saved profiles don't just break or lose their name
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

    // written by hand because CodingKeys includes legacyName, which has no
    // matching stored property — that's fine for decoding old data, but it
    // broke Swift's automatic Encodable synthesis, since it expects every
    // key to map to a real property. this just encodes the current fields,
    // never the legacy one, since we only ever need that for reading old
    // saved profiles, not writing new ones
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
