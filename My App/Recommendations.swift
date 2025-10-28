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
        let calendar = Calendar.current
        let today = Date()
        
        func reminder(title: String, type: String, years: Int = 0, months: Int = 0, days: Int = 0) -> Reminder? {
            guard let targetDate = calendar.date(byAdding: DateComponents(year: years, month: months, day: days), to: profile.dateOfBirth),
                  targetDate >= today else { return nil }
            return Reminder(title: title, date: targetDate, type: type)
        }
        
        switch profile.age {
        case 0..<2:
            reminders.append(contentsOf: [
                reminder(title: "DTaP Dose 3", type: "Vaccine", months: 6),
                reminder(title: "MMR Dose 1", type: "Vaccine", months: 12)
            ].compactMap { $0 })
        case 2..<12:
            reminders.append(contentsOf: [
                reminder(title: "Influenza Shot (Annual)", type: "Vaccine", years: profile.age)
            ].compactMap { $0 })
        case 12..<18:
            reminders.append(contentsOf: [
                reminder(title: "HPV Vaccine", type: "Vaccine", years: 12)
            ].compactMap { $0 })
        case 50...:
            reminders.append(contentsOf: [
                reminder(title: "Shingles Vaccine", type: "Vaccine", years: 50),
                reminder(title: "Flu Shot (Annual)", type: "Vaccine", years: profile.age)
            ].compactMap { $0 })
        default:
            break
        }
        
        if profile.age >= 21 {
            reminders.append(contentsOf: [
                reminder(title: "Cervical Cancer Screening (Pap Smear)", type: "Screening", years: 21),
            ].compactMap { $0 })
        }
        
        if profile.age >= 40 {
            reminders.append(contentsOf: [
                reminder(title: "Mammogram", type: "Screening", years: 40),
                reminder(title: "Cholesterol Check", type: "Screening", years: 40)
            ].compactMap { $0 })
        }
        
        if profile.age >= 45 {
            reminders.append(contentsOf: [
                reminder(title: "Colorectal Cancer Screening", type: "Screening", years: 45)
            ].compactMap { $0 })
        }
        
        if profile.gender == "Female", profile.age >= 50 {
            reminders.append(contentsOf: [
                reminder(title: "Osteoporosis Screening", type: "Screening", years: 50)
            ].compactMap { $0 })
        }
        
        return reminders
    }
}
