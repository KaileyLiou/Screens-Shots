//
//  ProfileStore.swift
//  My App
//
//  Created by Kailey Liou on 10/29/25.
//

import Foundation

// keeps the profile in memory and synced to UserDefaults so its still there
// next time the app opens. ObservableObject + @Published means any view
// showing profile.name updates automatically when it changes
class ProfileStore: ObservableObject {
    @Published var profile: Profile {
        didSet {
            saveProfile()
        }
    }
    
    private let profileKey = "user_profile"
    
    init() {
        if let data = UserDefaults.standard.data(forKey: profileKey),
           let decoded = try? JSONDecoder().decode(Profile.self, from: data) {
            self.profile = decoded
        } else {
            // first launch, no profile saved yet so start empty
            self.profile = Profile(name: "", dateOfBirth: Date(), gender: "", conditions: [])
        }
    }
    
    private func saveProfile() {
        if let encoded = try? JSONEncoder().encode(profile) {
            UserDefaults.standard.set(encoded, forKey: profileKey)
        }
    }
}
