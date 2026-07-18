//
//  RecommendationExplanations.swift
//  My App
//
//  Created by Kailey Liou on 7/18/26.
//

import Foundation

// simple text explanation for each recommendation, written
// once ahead of time and incorporated into the app instead of generated live by an
// AI at runtime. a live API call would mean putting an API key inside the
// shipped app and relying on a network call, so this is more simple and reliable
//
// matched by checking if a reminder's title contains one of these key
// phrases, most specific phrases checked first
struct RecommendationExplanations {

    private static let entries: [(match: String, text: String)] = [
        // most specific/family-history ones go first
        ("Discuss Earlier Mammogram Screening", "If breast cancer runs in your family, starting mammograms earlier than the usual age of 40 is sometimes recommended. This is a conversation to have with a doctor, since the right starting age depends on details like how old your relative was at diagnosis."),
        ("Discuss Earlier Colorectal Screening", "A family history of colorectal cancer can mean starting screening earlier than the usual age of 45. Like the mammogram case, the right starting point depends on your specific family history, so this is worth a direct conversation with a doctor."),
        ("Diabetic Eye Exam", "Diabetes can damage blood vessels in the retina over time, sometimes without any noticeable symptoms at first. An annual dilated eye exam catches this early, when it's most treatable."),

        ("Flu Shot", "The flu shot lowers your chances of getting the flu and tends to make it milder if you do get sick. It's updated most years to match the strains expected to spread."),
        ("Hepatitis B Vaccine", "Hepatitis B is a virus that can cause serious, long-term liver damage. This vaccine is usually given in a few doses starting right after birth."),
        ("DTaP Vaccine", "DTaP protects against three serious bacterial illnesses at once: diphtheria, tetanus, and whooping cough (pertussis), all of which can be especially dangerous for infants."),
        ("DTaP Booster", "This booster keeps up the protection from earlier DTaP doses against diphtheria, tetanus, and whooping cough as a child grows."),
        ("IPV Vaccine", "IPV protects against polio, a virus that can cause permanent paralysis. It's given as an inactivated (non-live) shot, which is why a few doses are needed to build full protection."),
        ("IPV Booster", "This booster finishes building full protection against polio."),
        ("Hib Vaccine", "Hib is a bacteria that can cause serious infections like meningitis in young children. This vaccine is most critical in the first year of life, before a child's immune system can fight it off well on its own."),
        ("PCV Vaccine", "PCV protects against pneumococcal bacteria, which can cause ear infections, pneumonia, and more serious infections like meningitis in young children."),
        ("Rotavirus Vaccine", "Rotavirus causes severe diarrhea and dehydration in infants. This vaccine is given orally rather than as a shot."),
        ("MMR Vaccine", "MMR protects against measles, mumps, and rubella — three viral illnesses that spread easily and can cause serious complications."),
        ("MMR Booster", "This booster makes sure protection against measles, mumps, and rubella stays strong as a child grows."),
        ("Varicella Vaccine", "This protects against chickenpox, which is usually mild in kids but can occasionally lead to serious complications, especially in adults who catch it later in life."),
        ("Varicella Booster", "This booster reinforces chickenpox protection from the earlier dose."),
        ("Hepatitis A Vaccine", "Hepatitis A is a liver infection usually spread through contaminated food or water. As of a 2026 update, this is now offered based on individual risk rather than recommended for every child, so it's worth discussing with a doctor."),
        ("HPV Vaccine", "HPV is a very common virus, and this vaccine significantly lowers the risk of several cancers it can cause later in life, including cervical cancer. It works best when given before someone is likely to have been exposed."),
        ("MenACWY Vaccine", "This protects against meningococcal bacteria, which can cause meningitis and bloodstream infections that progress quickly. As of a 2026 update, it's now offered based on individual risk, so it's worth a conversation with a doctor."),
        ("Tdap Vaccine", "Tdap boosts protection against tetanus, diphtheria, and whooping cough as childhood immunity starts to fade."),
        ("Tdap Booster", "Protection from Tdap fades over time, so a booster roughly every 10 years keeps it current."),
        ("Shingles Vaccine", "Shingles is a painful reactivation of the chickenpox virus that becomes more common with age. This vaccine significantly lowers the risk of getting it, and of the long-term nerve pain it can sometimes leave behind."),
        ("RSV Vaccine", "RSV is usually mild but can be serious for older adults. This is offered as a shared decision with a doctor rather than a blanket recommendation, since the right choice depends on individual health factors."),
        ("Pneumococcal Vaccine", "This protects older adults against pneumococcal bacteria, which can cause pneumonia and other serious infections. Current guidance favors a single, simpler dose (PCV20) over the older two-vaccine combination."),

        ("Cervical Cancer Screening", "A Pap smear checks for early cell changes on the cervix, long before they could become cancer. Catching things at this stage is a major reason cervical cancer is now largely preventable."),
        ("Mammogram", "A mammogram is an X-ray of breast tissue that can catch cancer well before it can be felt, when it's most treatable."),
        ("Colorectal Cancer Screening", "This checks for colorectal cancer or the polyps that can turn into it, often years before any symptoms would appear."),
        ("Cholesterol Screening", "High cholesterol usually has no symptoms at all, so a blood test is really the only way to know your numbers and catch a rising heart disease risk early."),
        ("Blood Pressure Check", "High blood pressure rarely causes any noticeable symptoms, which is exactly why regular checks matter — it's a major, largely silent risk factor for heart disease and stroke."),
        ("Osteoporosis Screening", "This checks bone density to catch osteoporosis before a fall leads to a serious fracture. Risk rises for women after menopause."),
        ("HIV Screening", "This is a one-time recommended test for everyone in this age range, regardless of perceived risk, since HIV can be present with no symptoms for years."),
        ("Hepatitis C Screening", "A one-time blood test recommended for this age range, since hepatitis C often causes no symptoms until it's already caused significant liver damage."),
        ("Prostate Cancer Screening Discussion", "Prostate screening isn't a one-size-fits-all yes — current guidance frames it as a personal decision to make with a doctor, weighing the potential benefits against the risk of overdiagnosis."),
    ]

    static func explanation(for title: String) -> String {
        for entry in entries {
            if title.contains(entry.match) {
                return entry.text
            }
        }
        // covers anything the user typed in themselves via Add Reminder,
        // since those aren't part of the built-in schedule
        return "This is a reminder you added yourself, so there's no built-in explanation for it."
    }
}
