//
//  Profile.swift
//  My App
//
//  Created by Kailey Liou on 10/26/25.
//

import Foundation

struct Profile: Identifiable, Codable {
    var id = UUID()
    var name: String
    var dateOfBirth: Date
    var gender: String
    var conditions: [String]
    var familyHistory: String = ""
    
    var age: Int {
        let calendar = Calendar.current
        return calendar.dateComponents([.year], from: dateOfBirth, to: Date()).year ?? 0
    }
}
