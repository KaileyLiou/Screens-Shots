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

        func makeReminder(title: String, type: String, monthsFromBirthday: Int = 0, yearsFromBirthday: Int = 0) -> Reminder {
            var date = dob
            if monthsFromBirthday > 0 {
                date = calendar.date(byAdding: .month, value: monthsFromBirthday, to: dob) ?? dob
            }
            if yearsFromBirthday > 0 {
                date = calendar.date(byAdding: .year, value: yearsFromBirthday, to: dob) ?? date
            }
            let targetDate = max(date, today)
            return Reminder(title: title, date: targetDate, type: type)
        }

        // Flu Shot (Annual)
        reminders.append(makeReminder(title: "Flu Shot (Annual)", type: "Vaccine", yearsFromBirthday: age))

        // Infant vaccines (multi-dose)
        if age < 1 {
            reminders.append(contentsOf: [
                // Hepatitis B
                makeReminder(title: "Hepatitis B Vaccine (Birth)", type: "Vaccine", monthsFromBirthday: 0),
                makeReminder(title: "Hepatitis B Vaccine (2 months)", type: "Vaccine", monthsFromBirthday: 2),
                makeReminder(title: "Hepatitis B Vaccine (6 months)", type: "Vaccine", monthsFromBirthday: 6),

                // DTaP
                makeReminder(title: "DTaP Vaccine (2 months)", type: "Vaccine", monthsFromBirthday: 2),
                makeReminder(title: "DTaP Vaccine (4 months)", type: "Vaccine", monthsFromBirthday: 4),
                makeReminder(title: "DTaP Vaccine (6 months)", type: "Vaccine", monthsFromBirthday: 6),
                makeReminder(title: "DTaP Vaccine (15 months)", type: "Vaccine", monthsFromBirthday: 15),

                // IPV (Polio)
                makeReminder(title: "IPV Vaccine (2 months)", type: "Vaccine", monthsFromBirthday: 2),
                makeReminder(title: "IPV Vaccine (4 months)", type: "Vaccine", monthsFromBirthday: 4),
                makeReminder(title: "IPV Vaccine (6 months)", type: "Vaccine", monthsFromBirthday: 6),

                // Hib
                makeReminder(title: "Hib Vaccine (2 months)", type: "Vaccine", monthsFromBirthday: 2),
                makeReminder(title: "Hib Vaccine (4 months)", type: "Vaccine", monthsFromBirthday: 4),
                makeReminder(title: "Hib Vaccine (6 months)", type: "Vaccine", monthsFromBirthday: 6),
                makeReminder(title: "Hib Vaccine (12 months)", type: "Vaccine", monthsFromBirthday: 12),

                // PCV
                makeReminder(title: "PCV Vaccine (2 months)", type: "Vaccine", monthsFromBirthday: 2),
                makeReminder(title: "PCV Vaccine (4 months)", type: "Vaccine", monthsFromBirthday: 4),
                makeReminder(title: "PCV Vaccine (6 months)", type: "Vaccine", monthsFromBirthday: 6),
                makeReminder(title: "PCV Vaccine (12 months)", type: "Vaccine", monthsFromBirthday: 12),

                // Rotavirus
                makeReminder(title: "Rotavirus Vaccine (2 months)", type: "Vaccine", monthsFromBirthday: 2),
                makeReminder(title: "Rotavirus Vaccine (4 months)", type: "Vaccine", monthsFromBirthday: 4),
                makeReminder(title: "Rotavirus Vaccine (6 months)", type: "Vaccine", monthsFromBirthday: 6)
            ])
        }

        // Toddlers/children vaccines
        if age >= 1 && age < 2 {
            reminders.append(contentsOf: [
                makeReminder(title: "MMR Vaccine (12-15 months)", type: "Vaccine", yearsFromBirthday: 1),
                makeReminder(title: "Varicella Vaccine (12-15 months)", type: "Vaccine", yearsFromBirthday: 1),
                makeReminder(title: "Hepatitis A Vaccine (12-23 months)", type: "Vaccine", yearsFromBirthday: 1)
            ])
        }

        if age >= 4 && age < 5 {
            reminders.append(contentsOf: [
                makeReminder(title: "DTaP Booster (4-5 years)", type: "Vaccine", yearsFromBirthday: 4),
                makeReminder(title: "IPV Booster (4-5 years)", type: "Vaccine", yearsFromBirthday: 4),
                makeReminder(title: "MMR Booster (4-6 years)", type: "Vaccine", yearsFromBirthday: 4),
                makeReminder(title: "Varicella Booster (4-6 years)", type: "Vaccine", yearsFromBirthday: 4)
            ])
        }

        // Teen vaccines
        if age >= 11 && age <= 12 {
            reminders.append(contentsOf: [
                makeReminder(title: "HPV Vaccine (11-12 years)", type: "Vaccine", yearsFromBirthday: 11),
                makeReminder(title: "MenACWY Vaccine (11-12 years)", type: "Vaccine", yearsFromBirthday: 11),
                makeReminder(title: "Tdap Vaccine (11-12 years)", type: "Vaccine", yearsFromBirthday: 11)
            ])
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

        // Screenings
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
        if gender == "Female" && age >= 65 {
            reminders.append(makeReminder(title: "Osteoporosis Screening", type: "Screening", yearsFromBirthday: 65))
        }

        return reminders.filter { $0.date >= today }
            .sorted { $0.date < $1.date }
    }
}
