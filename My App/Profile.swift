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
    var id = UUID()
    var name: String
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
}
