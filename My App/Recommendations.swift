//
//  Recommendations.swift
//  My App
//
//  Created by Kailey Liou on 10/26/25.
//

import Foundation

// builds a personalized schedule of vaccine/screening reminders based on the
// user's profile (age, gender, dob). follows cdc/acs guidelines instead of
// pulling from an api or ai since this is medical info and needs to be
// accurate + the same every time
struct VaccineRecommendations {

    static func recommendedReminders(for profile: Profile) -> [Reminder] {
        var reminders: [Reminder] = []
        let calendar = Calendar.current
        let dob = profile.dateOfBirth
        let today = Date()
        let age = profile.age
        let gender = profile.gender

        // builds one reminder at some offset from the user's birthday
        // months for early childhood stuff (those are scheduled every
        // few months) and years for everything after
        func makeReminder(title: String, type: String, monthsFromBirthday: Int = 0, yearsFromBirthday: Int = 0) -> Reminder {
            var date = dob
            if monthsFromBirthday > 0 {
                date = calendar.date(byAdding: .month, value: monthsFromBirthday, to: dob) ?? dob
            }
            if yearsFromBirthday > 0 {
                date = calendar.date(byAdding: .year, value: yearsFromBirthday, to: dob) ?? date
            }
            // if this already happened in the past (like a user who's
            // 30 hitting the "vaccine at age 2" one) just push it to today so
            // it still shows up as something to do
            let targetDate = max(date, today)
            return Reminder(title: title, date: targetDate, type: type, isGenerated: true)
        }

        // for stuff that actually repeats on a schedule (annual flu shot, a
        // screening every few years) instead of a one-time childhood milestone
        
        // finds a date that hasn't happened yet, so these land on a real future
        // date instead of every single one collapsing onto today the way a
        // one-time milestone does with the plain clamp above
        func makeRecurringReminder(title: String, type: String, anchorYearsFromBirthday: Int, intervalYears: Int) -> Reminder {
            var date = calendar.date(byAdding: .year, value: anchorYearsFromBirthday, to: dob) ?? dob
            while date < today {
                date = calendar.date(byAdding: .year, value: intervalYears, to: date) ?? date
            }
            return Reminder(title: title, date: date, type: type, isGenerated: true)
        }

        // Flu Shot (Annual). Note: as of the 2026 cdc update this is a shared
        // decision-making recommendation rather than a blanket one for everyone
        reminders.append(makeRecurringReminder(title: "Flu Shot (Annual, ask your doctor)", type: "Vaccine", anchorYearsFromBirthday: 0, intervalYears: 1))

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
                // note: exact schedule depends on the brand your doctor uses. some give a dose at 6 months,
                // others skip straight to 12-15 months
                // showing the more common 4-dose version here
                makeReminder(title: "Hib Vaccine (2 months)", type: "Vaccine", monthsFromBirthday: 2),
                makeReminder(title: "Hib Vaccine (4 months)", type: "Vaccine", monthsFromBirthday: 4),
                makeReminder(title: "Hib Vaccine (6 months, if applicable)", type: "Vaccine", monthsFromBirthday: 6),
                makeReminder(title: "Hib Vaccine (12 months)", type: "Vaccine", monthsFromBirthday: 12),

                // PCV
                makeReminder(title: "PCV Vaccine (2 months)", type: "Vaccine", monthsFromBirthday: 2),
                makeReminder(title: "PCV Vaccine (4 months)", type: "Vaccine", monthsFromBirthday: 4),
                makeReminder(title: "PCV Vaccine (6 months)", type: "Vaccine", monthsFromBirthday: 6),
                makeReminder(title: "PCV Vaccine (12 months)", type: "Vaccine", monthsFromBirthday: 12),

                // Rotavirus, now a shared decision-making vaccine as of the 2026 cdc update
                makeReminder(title: "Rotavirus Vaccine (2 months, ask your doctor)", type: "Vaccine", monthsFromBirthday: 2),
                makeReminder(title: "Rotavirus Vaccine (4 months, ask your doctor)", type: "Vaccine", monthsFromBirthday: 4),
                makeReminder(title: "Rotavirus Vaccine (6 months, ask your doctor)", type: "Vaccine", monthsFromBirthday: 6)
            ])
        }

        // Toddlers/children vaccines
        // note: as of the jan 2026 cdc schedule update, hepatitis a for kids moved from a
        // recommendation to risk-based/shared decision-making, so wording it softer
        // instead of stating it as a flat requirement
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

        // Teen vaccines
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
            // shared decision-making, not a fixed recommendation, so this one is more like "ask your doctor"
            reminders.append(makeReminder(title: "RSV Vaccine (60+, ask your doctor)", type: "Vaccine", yearsFromBirthday: 60))
        }

        if age >= 65 {
            // current guidance favors a single PCV20 dose over the older PCV13+PPSV23 combo
            reminders.append(makeReminder(title: "Pneumococcal Vaccine (PCV20, single dose)", type: "Vaccine", yearsFromBirthday: 65))
        }

        // Screenings
        // cervical screening stops around 65 if someone's been adequately screened
        // before then, so this needed an upper bound it didn't have before
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
        // uspstf grade a recommendation, one-time for everyone in this age range
        // regardless of risk factors
        if age >= 15 && age <= 65 {
            reminders.append(makeReminder(title: "HIV Screening (once, ages 15-65)", type: "Screening", yearsFromBirthday: 15))
        }
        // uspstf grade b, also just a one-time test for this age range
        if age >= 18 && age <= 79 {
            reminders.append(makeReminder(title: "Hepatitis C Screening (once, ages 18-79)", type: "Screening", yearsFromBirthday: 18))
        }
        // grade c, individualized decision rather than a fixed thing, so this
        // is worded as a conversation to have rather than a definite screening.
        // added so male users get a specific item too, same as female users
        // already do with mammogram/cervical/osteoporosis
        if gender == "Male" && age >= 55 && age <= 69 {
            reminders.append(makeReminder(title: "Prostate Cancer Screening Discussion (55-69, ask your doctor)", type: "Screening", yearsFromBirthday: 55))
        }

        // Conditions + family history based additions.
        // this is a first pass, just a few well-established
        // extra checks for the conditions/history people actually tend to enter
        let conditionsText = profile.conditions.joined(separator: " ").lowercased()
        let familyHistoryText = profile.familyHistory.lowercased()

        // diabetes needs a yearly dilated eye exam to catch retinopathy early,
        // regardless of age, this is standard ADA guidance
        if conditionsText.contains("diabetes") {
            reminders.append(makeRecurringReminder(title: "Diabetic Eye Exam (Annual)", type: "Screening", anchorYearsFromBirthday: 0, intervalYears: 1))
        }

        // family history can justify starting some screenings earlier than the
        // general population, phrased as a discussion since the exact earlier
        // age really depends on the relative's diagnosis age
        if gender == "Female" && age < 40 && (familyHistoryText.contains("breast cancer")) {
            reminders.append(makeReminder(title: "Discuss Earlier Mammogram Screening (Family History)", type: "Screening", yearsFromBirthday: age))
        }
        if age >= 40 && age < 45 && (familyHistoryText.contains("colon") || familyHistoryText.contains("colorectal")) {
            reminders.append(makeReminder(title: "Discuss Earlier Colorectal Screening (Family History)", type: "Screening", yearsFromBirthday: age))
        }

        // only show stuff that hasn't already passed, soonest first so it
        // matches whats on the dashboard
        return reminders.filter { $0.date >= today }
            .sorted { $0.date < $1.date }
    }
}
