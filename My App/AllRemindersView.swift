//
//  AllRemindersView.swift
//  My App
//
//  Created by Kailey Liou on 8/24/25.
//

import SwiftUI

struct AllRemindersView: View {
    @ObservedObject var reminderStore: ReminderStore
    @EnvironmentObject private var settingsStore: SettingsStore

    @State private var filterSelection: ReminderFilter = .upcoming
    @State private var searchText = ""
    @State private var selection = Set<UUID>()
    @Environment(\.editMode) private var editMode
    @State private var editingReminder: Reminder?

    enum ReminderFilter: String, CaseIterable, Identifiable {
        case upcoming = "Upcoming"
        case past = "Past"
        case all = "All"

        var id: String { self.rawValue }
    }

    // what actually shows in the list: filtered by the selected tab
    // (upcoming/past/all), then narrowed by the search box if its being used
    var filteredReminders: [Reminder] {
        let base: [Reminder]
        switch filterSelection {
        case .upcoming:
            base = reminderStore.reminders.filter { $0.date >= Calendar.current.startOfDay(for: Date()) }
        case .past:
            base = reminderStore.reminders.filter { $0.date < Calendar.current.startOfDay(for: Date()) }
        case .all:
            base = reminderStore.reminders
        }

        if searchText.isEmpty {
            return base
        } else {
            return base.filter {
                $0.title.localizedCaseInsensitiveContains(searchText) ||
                $0.type.localizedCaseInsensitiveContains(searchText)
            }
        }
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color(red: 0.97, green: 0.96, blue: 0.92)
                    .ignoresSafeArea()

                VStack(spacing: 15) {
                    Text("All Reminders")
                        .font(.system(size: 28, weight: .semibold, design: .rounded))
                        .foregroundColor(.black.opacity(0.8))

                    Picker("Filter", selection: $filterSelection) {
                        ForEach(ReminderFilter.allCases) { filter in
                            Text(filter.rawValue).tag(filter)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(.horizontal)
                    .padding(.top, 10)

                    if filteredReminders.isEmpty {
                        Spacer()
                        VStack {
                            Image(systemName: "bell.slash")
                                .font(.system(size: 40))
                                .foregroundColor(.gray.opacity(0.7))
                                .padding(.bottom, 5)
                            Text("No reminders found")
                                .foregroundColor(.gray)
                                .italic()
                        }
                        Spacer()
                    } else {
                        List(selection: $selection) {
                            ForEach(filteredReminders) { reminder in
                                ReminderCard(reminder: reminder)
                                    .listRowBackground(Color.clear)
                                    .listRowSeparator(.hidden)
                                    .contentShape(Rectangle())
                                    .onTapGesture {
                                        // outside of multi-select mode, tapping opens the
                                        // reminder for editing. in multi-select mode, List
                                        // already handles the tap as a selection toggle, so
                                        // we don't want to also open the edit sheet
                                        if editMode?.wrappedValue != .active {
                                            editingReminder = reminder
                                        }
                                    }
                            }
                            .onDelete(perform: deleteReminder)
                        }
                        .listStyle(PlainListStyle())
                    }
                }
                .searchable(text: $searchText, prompt: "Search by title or type")
                // same width cap as the other main screens
                .frame(maxWidth: 600)
                .frame(maxWidth: .infinity)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    if editMode?.wrappedValue == .active && !selection.isEmpty {
                        Button(role: .destructive) {
                            deleteSelected()
                        } label: {
                            Text("Delete (\(selection.count))")
                        }
                    }
                }
            }
            .sheet(item: $editingReminder) { reminder in
                AddReminderView(reminderStore: reminderStore, editingReminder: reminder)
                    .environmentObject(settingsStore)
            }
        }
    }

    func deleteReminder(at offsets: IndexSet) {
        // the swipe gives index positions from filteredReminders (whats on
        // screen), not the full reminders array. if a filter/search is on
        // those dont line up, so grab the actual objects first and remove
        // by matching them instead of trusting the raw index
        let itemsToDelete = offsets.map { filteredReminders[$0] }

        itemsToDelete.forEach { NotificationManager.cancelNotification(for: $0) }

        reminderStore.reminders.removeAll { reminder in
            itemsToDelete.contains(reminder)
        }
    }

    // deletes everything currently checked in multi-select mode, cancels
    // their notifications, then clears the selection and drops back out
    // of edit mode automatically
    func deleteSelected() {
        let itemsToDelete = reminderStore.reminders.filter { selection.contains($0.id) }

        itemsToDelete.forEach { NotificationManager.cancelNotification(for: $0) }

        reminderStore.reminders.removeAll { selection.contains($0.id) }
        selection.removeAll()
        editMode?.wrappedValue = .inactive
    }
}

#Preview {
    let store = ReminderStore()
    store.reminders = [
        Reminder(title: "Flu Shot", date: .now.addingTimeInterval(86400), type: "Vaccine"),
        Reminder(title: "Mammogram", date: .now.addingTimeInterval(-86400 * 5), type: "Screening")
    ]
    return AllRemindersView(reminderStore: store)
        .environmentObject(SettingsStore())
}

struct ReminderCard: View {
    let reminder: Reminder
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 6) {
                Text(reminder.title)
                    .font(.headline)
                    .foregroundColor(.black)
                
                Text(reminder.date.formatted(date: .abbreviated, time: .omitted))
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                Text(reminder.type)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(
                        reminder.type == "Vaccine" ?
                            Color(red: 0.40, green: 0.50, blue: 0.35).opacity(0.15)
                            : Color.blue.opacity(0.15)
                    )
                    .foregroundColor(reminder.type == "Vaccine" ?
                                     Color(red: 0.40, green: 0.50, blue: 0.35)
                                     : .blue)
                    .cornerRadius(8)
            }
            Spacer()
            
            Image(systemName: "bell.fill")
                .foregroundColor(Color(red: 0.40, green: 0.50, blue: 0.35))
                .imageScale(.large)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.08), radius: 5, x: 0, y: 3)
    }
}
