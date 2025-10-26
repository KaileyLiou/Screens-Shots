//
//  Recommendations.swift
//  My App
//
//  Created by Kailey Liou on 10/26/25.
//

import Foundation

struct VaccineRecommendations {
    static func recommendedReminders(for profile: Profile) -> [Reminder] {
        var reminders: [Reminder] = []
        
        switch profile.age {
        case 0..<2:
            reminders.append(Reminder(title: "DTaP Dose 3", date: Date().addingTimeInterval(30*24*60*60), type: "Vaccine"))
            reminders.append(Reminder(title: "MMR Dose 1", date: Date().addingTimeInterval(60*24*60*60), type: "Vaccine"))
        case 2..<12:
            reminders.append(Reminder(title: "Influenza Shot", date: Date().addingTimeInterval(7*24*60*60), type: "Vaccine"))
        case 12..<18:
            reminders.append(Reminder(title: "HPV Vaccine", date: Date().addingTimeInterval(10*24*60*60), type: "Vaccine"))
        case 50...:
            reminders.append(Reminder(title: "Shingles Vaccine", date: Date().addingTimeInterval(15*24*60*60), type: "Vaccine"))
            reminders.append(Reminder(title: "Flu Shot", date: Date().addingTimeInterval(7*24*60*60), type: "Vaccine"))
        default:
            break
        }
        
        return reminders
    }
}
