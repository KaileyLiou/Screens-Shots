//
//  ContentView.swift
//  My App
//
//  Created by Kailey Liou on 8/10/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var reminderStore = ReminderStore()
    @StateObject private var profileStore = ProfileStore()
    @State private var showingAddReminder = false
    @State private var showingProfile = false
    @State private var showProfileAlert = false
    @State private var showingSources = false

    // Next upcoming reminder
    var nextReminder: Reminder? {
        reminderStore.reminders
            .filter { $0.date.isTodayOrLater() }
            .sorted { $0.date < $1.date }
            .first
    }

    // Number of upcoming reminders
    var upcomingCount: Int {
        reminderStore.reminders.filter { $0.date.isTodayOrLater() }.count
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color.accentGreen
                    .ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 25) {

                        // MARK: - Header
                        VStack(spacing: 10) {
                            Text("Screens + Shots")
                                .font(.system(size: 36, weight: .bold, design: .rounded))
                                .foregroundColor(.white)

                            if !profileStore.profile.name.isEmpty {
                                Text("Welcome, \(profileStore.profile.name)!")
                                    .font(.title2)
                                    .foregroundColor(.white.opacity(0.85))
                            } else {
                                Text("Welcome!")
                                    .font(.title2)
                                    .foregroundColor(.white.opacity(0.85))
                            }
                        }
                        .padding(.top, 20)

                        // MARK: - Next Reminder Card
                        if let next = nextReminder {
                            DashboardCard(
                                title: "Next Reminder",
                                subtitle: "\(next.title) on \(next.date.formatted(date: .abbreviated, time: .omitted))",
                                icon: "bell.fill",
                                background: Color.white.opacity(0.15),
                                foregroundColor: .white,
                                showIndicator: true,
                                indicatorCount: upcomingCount
                            )
                            .padding(.horizontal)
                        } else {
                            DashboardCard(
                                title: "No Upcoming Reminders",
                                subtitle: "Add a reminder to get started",
                                icon: "bell.slash.fill",
                                background: Color.white.opacity(0.15),
                                foregroundColor: .white
                            )
                            .padding(.horizontal)
                        }

                        // MARK: - Action Buttons
                        VStack(spacing: 15) {
                            // Generate Recommendations Button
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
                                    background: .white
                                )
                            }
                            .alert("Please create a profile first", isPresented: $showProfileAlert) {
                                Button("OK") { showingProfile = true }
                            }

                            // Add Custom Reminder Button
                            Button {
                                showingAddReminder = true
                            } label: {
                                DashboardCard(
                                    title: "Add Custom Reminder",
                                    subtitle: "Create your own alert",
                                    icon: "plus.circle.fill",
                                    background: .white
                                )
                            }

                            // View All Reminders
                            NavigationLink {
                                AllRemindersView(reminders: $reminderStore.reminders)
                            } label: {
                                DashboardCard(
                                    title: "View All Reminders",
                                    subtitle: "See upcoming & past events",
                                    icon: "calendar",
                                    background: .white
                                )
                            }

                            // View Sources Button
                            Button {
                                showingSources = true
                            } label: {
                                DashboardCard(
                                    title: "View Sources",
                                    subtitle: "Trusted medical references",
                                    icon: "link",
                                    background: .white
                                )
                            }
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 20)

                        // MARK: - Disclaimer
                        Text("This app provides general health information and is not medical advice. Consult a doctor before making decisions.")
                            .font(.footnote)
                            .foregroundColor(.white.opacity(0.8))
                            .padding(.horizontal)
                            .multilineTextAlignment(.center)
                            .padding(.bottom, 40)
                    } // VStack
                } // ScrollView
            } // ZStack
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
            .sheet(isPresented: $showingSources) {
                SourcesView()
            }
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

// MARK: - DashboardCard
struct DashboardCard: View {
    let title: String
    let subtitle: String
    let icon: String
    var background: Color = .white
    var foregroundColor: Color = .accentGreen
    var showIndicator: Bool = false
    var indicatorCount: Int = 0

    @State private var isPressed = false

    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 30, weight: .medium))
                .foregroundColor(foregroundColor)
                .frame(width: 50, height: 50)
                .background(Color.white.opacity(0.2))
                .clipShape(Circle())

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(foregroundColor)
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundColor(foregroundColor.opacity(0.85))
            }

            Spacer()

            if showIndicator && indicatorCount > 0 {
                Text("\(indicatorCount)")
                    .font(.subheadline)
                    .foregroundColor(.white)
                    .padding(8)
                    .background(foregroundColor)
                    .clipShape(Circle())
            }
        }
        .padding()
        .background(background)
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.15), radius: 5, x: 0, y: 3)
        .scaleEffect(isPressed ? 0.97 : 1)
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isPressed)
    }
}

// MARK: - Preview
#Preview {
    ContentView()
}
