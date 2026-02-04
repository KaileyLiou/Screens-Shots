//
//  ContentView.swift
//  My App
//
//  Created by Kailey Liou on 8/10/25.
//

//import SwiftUI
//
//struct ContentView: View {
//    @StateObject private var reminderStore = ReminderStore()
//    @State private var showAddReminderView: Bool = false
//    
//    var nextReminder: Reminder? {
//        reminderStore.reminders.sorted { $0.date < $1.date }.first
//    }
//    
//    let healthTips: [String] = [
//        "Did you know? The HPV vaccine can prevent 90% of cervical cancers.",
//        "Getting at least 7–8 hours of sleep supports immune function and brain health.",
//        "Regular physical activity reduces your risk of heart disease and diabetes.",
//        "Taking breaks from screens helps prevent eye strain and mental fatigue.",
//        "Eating a balanced diet improves mood and cognitive performance."
//    ]
//
//    var dailyTip: String {
//        let day = Calendar.current.component(.day, from: Date())
//        return healthTips[day % healthTips.count]
//    }
//    
//    var body: some View {
//        TabView {
//            NavigationStack {
//                ZStack {
//                    Color(red: 0.40, green: 0.50, blue: 0.35)
//                        .ignoresSafeArea()
//                    
//                    ScrollView {
//                        VStack(alignment: .leading, spacing: 25) {
//                            HStack {
//                                Text("Screens + Shots")
//                                    .font(.largeTitle)
//                                    .fontWeight(.heavy)
//                                    .foregroundColor(.white)
//                                    Spacer()
//                            }
//                            .padding(.horizontal)
//                            
//                            VStack(alignment: .leading, spacing: 12) {
//                                Text("Next Reminder")
//                                    .font(.title2)
//                                    .fontWeight(.semibold)
//                                    .foregroundColor(.primary)
//
//                                if let next = nextReminder {
//                                    VStack(alignment: .leading, spacing: 4) {
//                                        Text(next.title)
//                                            .font(.headline)
//                                            .foregroundColor(.black)
//                                        Text(next.date.formatted(date: .long, time: .omitted))
//                                            .font(.subheadline)
//                                            .foregroundColor(.secondary)
//                                    }
//                                } else {
//                                    Text("No reminders yet.")
//                                        .font(.subheadline)
//                                        .foregroundColor(.secondary)
//                                }
//                            }
//                            .padding()
//                            .background(Color.white)
//                            .cornerRadius(16)
//                            .shadow(color: .black.opacity(0.1), radius: 6, x: 0, y: 3)
//                            .padding(.horizontal)
//                            
//                            VStack(alignment: .leading, spacing: 12) {
//                                Text("Health Tip of the Day")
//                                    .font(.title2)
//                                    .fontWeight(.semibold)
//                                    .foregroundColor(.primary)
//
//                                VStack(alignment: .leading, spacing: 5) {
//                                    Text("Did you know?")
//                                        .font(.headline)
//                                        .foregroundColor(.black)
//
//                                    Text(dailyTip)
//                                        .font(.subheadline)
//                                        .foregroundColor(.secondary)
//                                }
//                            }
//                            .padding()
//                            .background(Color.white)
//                            .cornerRadius(16)
//                            .shadow(color: .black.opacity(0.1), radius: 6, x: 0, y: 3)
//                            .padding(.horizontal)
//                        } // end of vstack
//                        .padding(.bottom, 40)
//                        
//                    } // end of scrollview
//                    
//                } // end of zstack
//                .toolbar {
//                    ToolbarItem(placement: .navigationBarTrailing) {
//                        Button {
//                            showAddReminderView = true
//                        } label: {
//                            Image(systemName: "plus")
//                                .foregroundColor(.white)
//                                .font(.title2)
//                        }
//                    }
//                }
//                
//            } // end of tab view
//            .tabItem {
//                Label("Home", systemImage: "house")
//            }
//            
//            AllRemindersView(reminders: $reminderStore.reminders)
//                .tabItem {
//                    Label("Reminders", systemImage: "list.bullet")
//                }
//            
//        } // end of nav stack
//        .sheet(isPresented: $showAddReminderView) {
//            AddReminderView(reminders: $reminderStore.reminders)
//        }
//    }
//}
//
//#Preview {
//    ContentView()
//}

import SwiftUI

struct ContentView: View {
    @StateObject private var reminderStore = ReminderStore()
    @StateObject private var profileStore = ProfileStore()
    @State private var showingAddReminder = false
    @State private var showingProfile = false
    @State private var showProfileAlert = false
    @State private var showingSources = false
    
    var nextReminderText: String {
        if let next = reminderStore.reminders
            .filter({ $0.date.isTodayOrLater() })
            .sorted(by: { $0.date < $1.date })
            .first {
            let formattedDate = next.date.formatted(date: .abbreviated, time: .omitted)
            return "Next: \(next.title) on \(formattedDate)"
        } else {
            return "No upcoming reminders"
        }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(red: 0.40, green: 0.50, blue: 0.35)
                    .ignoresSafeArea()
                ScrollView {
                    VStack(spacing: 30) {
                        VStack(spacing: 6) {
                            Text("Screens + Shots")
                                .font(.system(size: 36, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                            
                            VStack(spacing: 10) {
                                if !profileStore.profile.name.isEmpty {
                                    Text("Welcome, \(profileStore.profile.name)!")
                                        .font(.title2)
                                        .foregroundColor(.white.opacity(0.85))
                                } else {
                                    Text("Welcome!")
                                        .font(.title2)
                                        .foregroundColor(.white.opacity(0.85))
                                }
                                Spacer().frame(height: 10)
                            }
                            .padding(.top, 20)
                            
                            VStack {
                                if let next = reminderStore.reminders
                                    .filter({ $0.date.isTodayOrLater() })
                                    .sorted(by: { $0.date < $1.date })
                                    .first {

                                    VStack(spacing: 6) {
                                        Text("Next Reminder")
                                            .font(.headline)
                                            .foregroundColor(.white.opacity(0.9))
                                        Text(next.title)
                                            .font(.title2.bold())
                                            .foregroundColor(.white)
                                        Text(next.date.formatted(date: .abbreviated, time: .omitted))
                                            .font(.subheadline)
                                            .foregroundColor(.white.opacity(0.8))
                                    }
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(Color.white.opacity(0.15))
                                    .cornerRadius(12)
                                    .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 3)
                                    .padding(.horizontal)
                                } else {
                                    Text("No upcoming reminders")
                                        .font(.headline)
                                        .foregroundColor(.white.opacity(0.8))
                                        .padding()
                                        .frame(maxWidth: .infinity)
                                        .background(Color.white.opacity(0.1))
                                        .cornerRadius(12)
                                        .padding(.horizontal)
                                }
                            }

                        }
                        .padding(.top, 20)

                        VStack(spacing: 18) {
                            Button {
                                if profileStore.profile.name.isEmpty {
                                    showProfileAlert = true
                                } else {
                                    let newReminders = VaccineRecommendations.recommendedReminders(for: profileStore.profile)

                                    let uniqueReminders = newReminders.filter { newReminder in
                                        !reminderStore.reminders.contains(where: { existing in
                                            existing.title == newReminder.title && existing.date == newReminder.date
                                        })
                                    }
                                    
                                    if !uniqueReminders.isEmpty {
                                        withAnimation {
                                            reminderStore.reminders.append(contentsOf: uniqueReminders)
                                        }
                                    }
                                }
                            } label: {
                                DashboardCard(
                                    title: "Generate Recommendations",
                                    subtitle: "Based on your profile",
                                    icon: "syringe",
                                    background: Color.white
                                )
                            }

                            .alert("Please create a profile first", isPresented: $showProfileAlert) {
                                Button("OK") {
                                    showingProfile = true
                                }
                            }
                            
                            Button {
                                showingAddReminder = true
                            } label: {
                                DashboardCard(
                                    title: "Add Custom Reminder",
                                    subtitle: "Create your own screening or vaccine alert",
                                    icon: "plus.circle.fill",
                                    background: Color.white
                                )
                            }
                            
                            NavigationLink {
                                AllRemindersView(reminders: $reminderStore.reminders)
                            } label: {
                                DashboardCard(
                                    title: "View All Reminders",
                                    subtitle: "See upcoming and past events",
                                    icon: "calendar",
                                    background: Color.white
                                )
                            }
                            
//                            Button {
//                                showingSources = true
//                            } label: {
//                                HStack {
//                                    Image(systemName: "link")
//                                    Text("View Sources")
//                                }
//                                .font(.subheadline)
//                                .foregroundColor(Color(red: 0.40, green: 0.50, blue: 0.35))
//                                .padding()
//                                .background(Color.white)
//                                .cornerRadius(10)
//                            }
//                            .sheet(isPresented: $showingSources) {
//                                SourcesView()
//                            }
                            
                        }
                        .padding(.horizontal)
                        
                        Spacer()
                        
                        VStack(spacing: 15) {
                            Text("⚠️ This app provides general health information and is not medical advice. Consult a doctor before making decisions.")
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.9))
                                .padding()
                                .background(Color.black.opacity(0.2))
                                .cornerRadius(12)
                                .padding(.horizontal)
                            Button {
                                showingSources = true
                            } label: {
                                HStack {
                                    Image(systemName: "link")
                                    Text("View Sources")
                                }
                                .font(.footnote)
                                .foregroundColor(Color(red: 0.40, green: 0.50, blue: 0.35))
                                .padding(.vertical, 10)
                                .padding(.horizontal, 16)
                                .background(Color.white)
                                .cornerRadius(10)
                            }
                            .sheet(isPresented: $showingSources) {
                                SourcesView()
                            }

                        }
                    }
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button {
                                showingProfile = true
                            } label: {
                                Image(systemName: "person.crop.circle")
                                    .font(.title2)
                                    .foregroundColor(.white)
                            }
                        }
                    }
                    .sheet(isPresented: $showingAddReminder) {
                        AddReminderView(reminders: $reminderStore.reminders)
                    }
                    .sheet(isPresented: $showingProfile) {
                        ProfileView(profile: $profileStore.profile)
                    }
                    .navigationTitle("")
                    .navigationBarTitleDisplayMode(.inline)
                }
            }
        }
    }

    struct DashboardCard: View {
        let title: String
        let subtitle: String
        let icon: String
        let background: Color
        
        var body: some View {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(Color(red: 0.40, green: 0.50, blue: 0.35).opacity(0.2))
                        .frame(width: 50, height: 50)
                    Image(systemName: icon)
                        .font(.title2)
                        .foregroundColor(Color(red: 0.40, green: 0.50, blue: 0.35))
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.headline)
                        .foregroundColor(.black)
                    Text(subtitle)
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                Spacer()
            }
            .padding()
            .background(background)
            .cornerRadius(15)
            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 3)
        }
    }
}

#Preview {
    ContentView()
}
