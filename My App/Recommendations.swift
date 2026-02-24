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
        let dob = profile.dateOfBirth
        let today = Date()
        let age = profile.age
        let gender = profile.gender

        func makeReminder(title: String, type: String, yearsFromBirthday: Int = 0) -> Reminder {
            guard let targetDate = calendar.date(byAdding: .year, value: yearsFromBirthday, to: dob) else {
                return Reminder(title: title, date: today, type: type)
            }
            return Reminder(title: title, date: targetDate, type: type)
        }

        reminders.append(makeReminder(title: "Flu Shot (Annual)", type: "Vaccine", yearsFromBirthday: age))

        if age < 1 {
            reminders.append(contentsOf: [
                makeReminder(title: "Hepatitis B Vaccine", type: "Vaccine", yearsFromBirthday: 0),
                makeReminder(title: "RSV Vaccine", type: "Vaccine", yearsFromBirthday: 0),
                makeReminder(title: "DTaP Vaccine", type: "Vaccine", yearsFromBirthday: 0),
                makeReminder(title: "Hib Vaccine", type: "Vaccine", yearsFromBirthday: 0),
                makeReminder(title: "IPV Vaccine", type: "Vaccine", yearsFromBirthday: 0),
                makeReminder(title: "PCV Vaccine", type: "Vaccine", yearsFromBirthday: 0),
                makeReminder(title: "Rotavirus Vaccine", type: "Vaccine", yearsFromBirthday: 0),
                makeReminder(title: "Diphtheria Vaccine", type: "Vaccine", yearsFromBirthday: 0),
                makeReminder(title: "Pneumococcal Vaccine", type: "Vaccine", yearsFromBirthday: 0),
                makeReminder(title: "Polio Vaccine", type: "Vaccine", yearsFromBirthday: 0),
                makeReminder(title: "Tetanus Vaccine", type: "Vaccine", yearsFromBirthday: 0),
                makeReminder(title: "Whooping Cough Vaccine", type: "Vaccine", yearsFromBirthday: 0)
            ])
        }

        if age >= 1 && age < 2 {
            reminders.append(contentsOf: [
                makeReminder(title: "Chickenpox Vaccine", type: "Vaccine", yearsFromBirthday: 1),
                makeReminder(title: "Hepatitis A Vaccine", type: "Vaccine", yearsFromBirthday: 1),
                makeReminder(title: "MMR Vaccine", type: "Vaccine", yearsFromBirthday: 1),
                makeReminder(title: "Measles Vaccine", type: "Vaccine", yearsFromBirthday: 1),
                makeReminder(title: "Mumps Vaccine", type: "Vaccine", yearsFromBirthday: 1),
                makeReminder(title: "Rubella Vaccine", type: "Vaccine", yearsFromBirthday: 1)
            ])
        }

        if age >= 2 && age < 5 {
            reminders.append(contentsOf: [
                makeReminder(title: "DTaP Booster", type: "Vaccine", yearsFromBirthday: 4),
                makeReminder(title: "IPV Booster", type: "Vaccine", yearsFromBirthday: 4),
                makeReminder(title: "MMR Booster", type: "Vaccine", yearsFromBirthday: 4),
                makeReminder(title: "Polio Booster", type: "Vaccine", yearsFromBirthday: 4)
            ])
        }
        
        if age >= 11 && age <= 12 {
            reminders.append(contentsOf: [
                makeReminder(title: "HPV Booster", type: "Vaccine", yearsFromBirthday: 4),
                makeReminder(title: "MenACWY Vaccine", type: "Vaccine", yearsFromBirthday: 4),
                makeReminder(title: "Tdap Vaccine", type: "Vaccine", yearsFromBirthday: 4)
            ])
        }
        
        if age >= 13 && age < 19 {
            reminders.append(makeReminder(title: "Td Vaccine", type: "Vaccine", yearsFromBirthday: 4))
        }

        if age >= 19 {
            reminders.append(makeReminder(title: "Tdap Booster (Every 10 Years)", type: "Vaccine", yearsFromBirthday: 19))
        }

        if age >= 50 {
            reminders.append(makeReminder(title: "Shingles Vaccine (2 doses starting at 50)", type: "Vaccine", yearsFromBirthday: 50))
        }

        if age >= 65 {
            reminders.append(makeReminder(title: "Pneumococcal Vaccine", type: "Vaccine", yearsFromBirthday: 65))
        }

        if gender == "Female" && age >= 21 {
            reminders.append(makeReminder(title: "Cervical Cancer Screening (Pap Smear every 3 years)", type: "Screening", yearsFromBirthday: 21))
        }

        if gender == "Female" && age >= 40 {
            reminders.append(makeReminder(title: "Mammogram (every 2 years)", type: "Screening", yearsFromBirthday: 40))
        }

        if age >= 45 {
            reminders.append(makeReminder(title: "Colorectal Cancer Screening (every 3 years)", type: "Screening", yearsFromBirthday: 45))
        }

        if age >= 20 {
            reminders.append(makeReminder(title: "Cholesterol Screening (every 5 years)", type: "Screening", yearsFromBirthday: 20))
        }

        if age >= 18 {
            reminders.append(makeReminder(title: "Blood Pressure Check (every 2 years)", type: "Screening", yearsFromBirthday: 18))
        }

        if gender == "Female", age >= 65 {
            reminders.append(makeReminder(title: "Osteoporosis Screening", type: "Screening", yearsFromBirthday: 65))
        }

        let futureReminders = reminders.filter { $0.date >= today }

        return futureReminders.sorted { $0.date < $1.date }
    }
}
