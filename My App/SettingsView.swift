//
//  SettingsView.swift
//  My App
//
//  Created by Kailey Liou on 7/15/26.
//

import SwiftUI

struct SettingsView: View {
    @ObservedObject var settingsStore: SettingsStore
    @ObservedObject var profileStore: ProfileStore
    @ObservedObject var reminderStore: ReminderStore
    @Environment(\.dismiss) var dismiss

    @State private var showingDeleteConfirmation = false
    @State private var showingSources = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {

                    // matches the header style used on ProfileView so the two screens feel like part of the same app
                    Text("Settings")
                        .font(.system(size: 28, weight: .semibold, design: .rounded))
                        .foregroundColor(.black.opacity(0.8))

                    SettingsSection(title: "Notifications") {
                        Toggle(isOn: $settingsStore.notificationsEnabled) {
                            Label("Reminder Notifications", systemImage: "bell.badge.fill")
                        }
                        .tint(.accentGreen)

                        if settingsStore.notificationsEnabled {
                            Divider()
                            DatePicker(
                                "Reminder Time",
                                selection: $settingsStore.notificationTime,
                                displayedComponents: .hourAndMinute
                            )
                        }
                    }

                    SettingsSection(title: "Appearance") {
                        Picker("Appearance", selection: $settingsStore.appearanceMode) {
                            ForEach(AppearanceMode.allCases) { mode in
                                Text(mode.rawValue).tag(mode)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                    }

                    SettingsSection(title: "About") {
                        Button {
                            showingSources = true
                        } label: {
                            Label("View Sources", systemImage: "link")
                                .foregroundColor(.accentGreen)
                        }

                        Divider()

                        HStack {
                            Label("Version", systemImage: "info.circle")
                            Spacer()
                            Text(Bundle.main.appVersionString)
                                .foregroundColor(.gray)
                        }
                    }

                    SettingsSection(title: "Reset") {
                        Button(role: .destructive) {
                            showingDeleteConfirmation = true
                        } label: {
                            Label("Delete All Data", systemImage: "trash.fill")
                        }

                        Text("This clears your profile and every reminder, and can't be undone.")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
                .padding()
            }
            .background(Color.background)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Done") { dismiss() }
                }
            }
            .confirmationDialog(
                "Delete all your data? This can't be undone.",
                isPresented: $showingDeleteConfirmation,
                titleVisibility: .visible
            ) {
                Button("Delete Everything", role: .destructive) {
                    // cancel notifications first, before the reminders they point to are gone
                    reminderStore.reminders.forEach { NotificationManager.cancelNotification(for: $0) }
                    reminderStore.reminders = []
                    profileStore.profile = Profile(name: "", dateOfBirth: Date(), gender: "", conditions: [])
                }
                Button("Cancel", role: .cancel) { }
            }
            .sheet(isPresented: $showingSources) {
                SourcesView()
            }
        }
    }
}

// small card wrapper so each settings group looks like the rounded white cards used
// everywhere else in the app (dashboard, profile, etc)
private struct SettingsSection<Content: View>: View {
    let title: String
    @ViewBuilder let content: Content

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.headline)

            VStack(alignment: .leading, spacing: 12) {
                content
            }
            .padding()
            .background(Color.white)
            .cornerRadius(15)
            .shadow(color: .black.opacity(0.06), radius: 4, x: 0, y: 2)
        }
    }
}

extension Bundle {
    // pulls the version + build number straight from the project settings,
    // so this never goes out of sync with what's actually shipped
    var appVersionString: String {
        let version = infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
        let build = infoDictionary?["CFBundleVersion"] as? String ?? "1"
        return "\(version) (\(build))"
    }
}

#Preview {
    SettingsView(settingsStore: SettingsStore(), profileStore: ProfileStore(), reminderStore: ReminderStore())
}
