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
            return Reminder(title: title, date: targetDate, type: type, isGenerated: true)
        }

        func makeRecurringReminder(title: String, type: String, anchorYearsFromBirthday: Int, intervalYears: Int) -> Reminder {
            var date = calendar.date(byAdding: .year, value: anchorYearsFromBirthday, to: dob) ?? dob
            while date < today {
                date = calendar.date(byAdding: .year, value: intervalYears, to: date) ?? date
            }
            return Reminder(title: title, date: date, type: type, isGenerated: true)
        }

        reminders.append(makeRecurringReminder(title: "Flu Shot (Annual, ask your doctor)", type: "Vaccine", anchorYearsFromBirthday: 0, intervalYears: 1))

        // infant vaccines
        if age < 1 {
            reminders.append(contentsOf: [
                // hepatitis b
                makeReminder(title: "Hepatitis B Vaccine (Birth)", type: "Vaccine", monthsFromBirthday: 0),
                makeReminder(title: "Hepatitis B Vaccine (2 months)", type: "Vaccine", monthsFromBirthday: 2),
                makeReminder(title: "Hepatitis B Vaccine (6 months)", type: "Vaccine", monthsFromBirthday: 6),

                // dtap
                makeReminder(title: "DTaP Vaccine (2 months)", type: "Vaccine", monthsFromBirthday: 2),
                makeReminder(title: "DTaP Vaccine (4 months)", type: "Vaccine", monthsFromBirthday: 4),
                makeReminder(title: "DTaP Vaccine (6 months)", type: "Vaccine", monthsFromBirthday: 6),
                makeReminder(title: "DTaP Vaccine (15 months)", type: "Vaccine", monthsFromBirthday: 15),

                // ipv (polio)
                makeReminder(title: "IPV Vaccine (2 months)", type: "Vaccine", monthsFromBirthday: 2),
                makeReminder(title: "IPV Vaccine (4 months)", type: "Vaccine", monthsFromBirthday: 4),
                makeReminder(title: "IPV Vaccine (6 months)", type: "Vaccine", monthsFromBirthday: 6),

                // hib
                makeReminder(title: "Hib Vaccine (2 months)", type: "Vaccine", monthsFromBirthday: 2),
                makeReminder(title: "Hib Vaccine (4 months)", type: "Vaccine", monthsFromBirthday: 4),
                makeReminder(title: "Hib Vaccine (6 months, if applicable)", type: "Vaccine", monthsFromBirthday: 6),
                makeReminder(title: "Hib Vaccine (12 months)", type: "Vaccine", monthsFromBirthday: 12),

                // pcv
                makeReminder(title: "PCV Vaccine (2 months)", type: "Vaccine", monthsFromBirthday: 2),
                makeReminder(title: "PCV Vaccine (4 months)", type: "Vaccine", monthsFromBirthday: 4),
                makeReminder(title: "PCV Vaccine (6 months)", type: "Vaccine", monthsFromBirthday: 6),
                makeReminder(title: "PCV Vaccine (12 months)", type: "Vaccine", monthsFromBirthday: 12),

                // rotavirus
                makeReminder(title: "Rotavirus Vaccine (2 months, ask your doctor)", type: "Vaccine", monthsFromBirthday: 2),
                makeReminder(title: "Rotavirus Vaccine (4 months, ask your doctor)", type: "Vaccine", monthsFromBirthday: 4),
                makeReminder(title: "Rotavirus Vaccine (6 months, ask your doctor)", type: "Vaccine", monthsFromBirthday: 6)
            ])
        }

        // children vaccines
        if age >= 1 && age < 2 {
            reminders.append(contentsOf: [
                makeReminder(title: "MMR Vaccine (12-15 months)", type: "Vaccine", yearsFromBirthday: 1),
                makeReminder(title: "Varicella Vaccine (12-15 months)", type: "Vaccine", yearsFromBirthday: 1),
                makeReminder(title: "Hepatitis A Vaccine (12-23 months, ask your doctor)", type: "Vaccine", yearsFromBirthday: 1)
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

        // teen vaccines
        if age >= 11 && age <= 12 {
            reminders.append(contentsOf: [
                makeReminder(title: "HPV Vaccine (11-12 years)", type: "Vaccine", yearsFromBirthday: 11),
                makeReminder(title: "MenACWY Vaccine (11-12 years, ask your doctor)", type: "Vaccine", yearsFromBirthday: 11),
                makeReminder(title: "Tdap Vaccine (11-12 years)", type: "Vaccine", yearsFromBirthday: 11)
            ])
        }

        if age >= 19 {
            reminders.append(makeRecurringReminder(title: "Tdap Booster (Every 10 Years)", type: "Vaccine", anchorYearsFromBirthday: 19, intervalYears: 10))
        }

        if age >= 50 {
            reminders.append(makeReminder(title: "Shingles Vaccine (2 doses starting at 50)", type: "Vaccine", yearsFromBirthday: 50))
        }

        if age >= 60 {
            reminders.append(makeReminder(title: "RSV Vaccine (60+, ask your doctor)", type: "Vaccine", yearsFromBirthday: 60))
        }

        if age >= 65 {
            reminders.append(makeReminder(title: "Pneumococcal Vaccine (PCV20, single dose)", type: "Vaccine", yearsFromBirthday: 65))
        }

        // screenings
        if gender == "Female" && age >= 21 && age <= 65 {
            reminders.append(makeRecurringReminder(title: "Cervical Cancer Screening (Pap Smear every 3 years)", type: "Screening", anchorYearsFromBirthday: 21, intervalYears: 3))
        }
        if gender == "Female" && age >= 40 {
            reminders.append(makeRecurringReminder(title: "Mammogram (every 2 years)", type: "Screening", anchorYearsFromBirthday: 40, intervalYears: 2))
        }
        if age >= 45 {
            reminders.append(makeRecurringReminder(title: "Colorectal Cancer Screening (every 3 years)", type: "Screening", anchorYearsFromBirthday: 45, intervalYears: 3))
        }
        if age >= 20 {
            reminders.append(makeRecurringReminder(title: "Cholesterol Screening (every 5 years)", type: "Screening", anchorYearsFromBirthday: 20, intervalYears: 5))
        }
        if age >= 18 {
            reminders.append(makeRecurringReminder(title: "Blood Pressure Check (every 2 years)", type: "Screening", anchorYearsFromBirthday: 18, intervalYears: 2))
        }
        if gender == "Female" && age >= 65 {
            reminders.append(makeReminder(title: "Osteoporosis Screening", type: "Screening", yearsFromBirthday: 65))
        }
        if age >= 15 && age <= 65 {
            reminders.append(makeReminder(title: "HIV Screening (once, ages 15-65)", type: "Screening", yearsFromBirthday: 15))
        }
        if age >= 18 && age <= 79 {
            reminders.append(makeReminder(title: "Hepatitis C Screening (once, ages 18-79)", type: "Screening", yearsFromBirthday: 18))
        }
        if gender == "Male" && age >= 55 && age <= 69 {
            reminders.append(makeReminder(title: "Prostate Cancer Screening Discussion (55-69, ask your doctor)", type: "Screening", yearsFromBirthday: 55))
        }

        let conditionsText = profile.conditions.joined(separator: " ").lowercased()
        let familyHistoryText = profile.familyHistory.lowercased()

        if conditionsText.contains("diabetes") {
            reminders.append(makeRecurringReminder(title: "Diabetic Eye Exam (Annual)", type: "Screening", anchorYearsFromBirthday: 0, intervalYears: 1))
        }

        if gender == "Female" && age < 40 && (familyHistoryText.contains("breast cancer")) {
            reminders.append(makeReminder(title: "Discuss Earlier Mammogram Screening (Family History)", type: "Screening", yearsFromBirthday: age))
        }
        if age >= 40 && age < 45 && (familyHistoryText.contains("colon") || familyHistoryText.contains("colorectal")) {
            reminders.append(makeReminder(title: "Discuss Earlier Colorectal Screening (Family History)", type: "Screening", yearsFromBirthday: age))
        }

        return reminders.filter { $0.date >= today }
            .sorted { $0.date < $1.date }
    }
}
