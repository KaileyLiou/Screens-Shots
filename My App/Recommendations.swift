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
        let age = profile.age
        let gender = profile.gender
        let calendar = Calendar.current
        let today = Date()
        
        func makeReminder(title: String, type: String, yearsFromNow: Int = 0) -> Reminder {
            let targetDate = calendar.date(byAdding: .year, value: yearsFromNow, to: today) ?? today
            return Reminder(title: title, date: targetDate, type: type)
        }
        
        reminders.append(makeReminder(title: "Flu Shot (Annual)", type: "Vaccine"))
        
        if age < 1 {
            reminders.append(makeReminder(title: "Hepatitis B Vaccine", type: "Vaccine"))
            reminders.append(makeReminder(title: "DTaP Vaccine", type: "Vaccine"))
            reminders.append(makeReminder(title: "Polio Vaccine", type: "Vaccine"))
            reminders.append(makeReminder(title: "Hib Vaccine", type: "Vaccine"))
        }
        
        if age >= 1 && age < 2 {
            reminders.append(makeReminder(title: "MMR Vaccine", type: "Vaccine"))
            reminders.append(makeReminder(title: "Varicella Vaccine", type: "Vaccine"))
        }
        
        if age >= 2 && age < 5 {
            reminders.append(makeReminder(title: "DTaP Booster", type: "Vaccine"))
            reminders.append(makeReminder(title: "Polio Booster", type: "Vaccine"))
        }
        
        if age >= 19 {
            reminders.append(makeReminder(title: "Tdap Booster (Every 10 Years)", type: "Vaccine"))
        }
        
        if age >= 50 {
            reminders.append(makeReminder(title: "Shingles Vaccine (2 doses starting at 50)", type: "Vaccine"))
        }
        
        if age >= 65 {
            reminders.append(makeReminder(title: "Pneumococcal Vaccine", type: "Vaccine"))
        }
        
        if gender == "Female" && age >= 21 {
            reminders.append(makeReminder(title: "Cervical Cancer Screening (Pap Smear every 3 years)", type: "Screening"))
        }
        
        if gender == "Female" && age >= 40 {
            reminders.append(makeReminder(title: "Mammogram (every 2 years)", type: "Screening"))
        }
        
        if age >= 45 {
            reminders.append(makeReminder(title: "Colorectal Cancer Screening (every 3 years)", type: "Screening"))
        }
        
        if age >= 20 {
            reminders.append(makeReminder(title: "Cholesterol Screening (every 5 years)", type: "Screening"))
        }
        
        if age >= 18 {
            reminders.append(makeReminder(title: "Blood Pressure Check (every 2 years)", type: "Screening"))
        }
        
        if gender == "Female", age >= 65 {
            reminders.append(makeReminder(title: "Osteoporosis Screening", type: "Screening"))
        }
        
        return reminders
    }
}
