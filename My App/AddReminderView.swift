//
//  AddReminderView.swift
//  My App
//
//  Created by Kailey Liou on 8/24/25.
//

import SwiftUI

struct AddReminderView: View {
    @ObservedObject var reminderStore: ReminderStore
    @EnvironmentObject private var settingsStore: SettingsStore
    @Environment(\.dismiss) var dismiss

    var editingReminder: Reminder?

    @State private var title: String
    @State private var date: Date
    @State private var type: String
    @State private var repeatInterval: RepeatInterval
    @FocusState private var titleFieldIsFocused: Bool

    private var isCustomReminder: Bool {
        editingReminder?.isGenerated != true
    }

    init(reminderStore: ReminderStore, editingReminder: Reminder? = nil) {
        self.reminderStore = reminderStore
        self.editingReminder = editingReminder
        _title = State(initialValue: editingReminder?.title ?? "")
        _date = State(initialValue: editingReminder?.date ?? Date())
        _type = State(initialValue: editingReminder?.type ?? "Vaccine")
        _repeatInterval = State(initialValue: editingReminder?.repeatInterval ?? .none)
    }

    var canSave: Bool {
        !title.trimmingCharacters(in: .whitespaces).isEmpty
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color(red: 0.97, green: 0.96, blue: 0.92)
                    .ignoresSafeArea()
                    .onTapGesture {
                        titleFieldIsFocused = false
                    }
                
                ScrollView {
                    VStack {
                        Text(editingReminder == nil ? "New Reminder" : "Edit Reminder")
                            .font(.system(size: 28, weight: .semibold, design: .rounded))
                            .foregroundColor(.black.opacity(0.8))
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding(.top, 20)
                            .padding(.horizontal)
                        
                        VStack(spacing: 20) {
                            TextField("Enter reminder title", text: $title)
                                .focused($titleFieldIsFocused)
                                .submitLabel(.done)
                                .onSubmit { titleFieldIsFocused = false }
                                .padding()
                                .background(Color(red: 0.95, green: 0.95, blue: 0.95))
                                .cornerRadius(10)
                            
                            DatePicker("Select Date", selection: $date, displayedComponents: .date)
                                .datePickerStyle(.graphical)
                                .padding()
                                .background(Color.white)
                                .cornerRadius(10)
                            
                            Picker("Reminder Type", selection: $type) {
                                Text("Vaccine").tag("Vaccine")
                                Text("Screening").tag("Screening")
                            }
                            .pickerStyle(SegmentedPickerStyle())
                            .padding()
                            .background(Color(red: 0.95, green: 0.95, blue: 0.95))
                            .cornerRadius(10)

                            if isCustomReminder {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Repeat")
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                    Picker("Repeat", selection: $repeatInterval) {
                                        ForEach(RepeatInterval.allCases) { interval in
                                            Text(interval.rawValue).tag(interval)
                                        }
                                    }
                                    .pickerStyle(SegmentedPickerStyle())
                                }
                                .padding()
                                .background(Color(red: 0.95, green: 0.95, blue: 0.95))
                                .cornerRadius(10)
                            }
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(20)
                        .shadow(color: .black.opacity(0.1), radius: 6, x: 0, y: 3)
                        .padding(.horizontal)
                        
                        Spacer(minLength: 20)
                        
                        Button(action: {
                            if let existing = editingReminder {

                                NotificationManager.cancelNotification(for: existing)
                                let updated = Reminder(
                                    id: existing.id,
                                    title: title,
                                    date: date,
                                    type: type,
                                    isGenerated: existing.isGenerated,
                                    repeatInterval: isCustomReminder ? repeatInterval : .none
                                )
                                if let index = reminderStore.reminders.firstIndex(where: { $0.id == existing.id }) {
                                    reminderStore.reminders[index] = updated
                                }
                                NotificationManager.scheduleNotification(
                                    for: updated,
                                    hour: settingsStore.notificationHour,
                                    minute: settingsStore.notificationMinute,
                                    enabled: settingsStore.notificationsEnabled
                                )
                            } else {
                                let newReminder = Reminder(title: title, date: date, type: type, isGenerated: false, repeatInterval: repeatInterval)
                                reminderStore.addIfUnique(newReminder)
                                NotificationManager.scheduleNotification(
                                    for: newReminder,
                                    hour: settingsStore.notificationHour,
                                    minute: settingsStore.notificationMinute,
                                    enabled: settingsStore.notificationsEnabled
                                )
                            }
                            dismiss()
                        }) {
                            Text(editingReminder == nil ? "Save Reminder" : "Save Changes")
                                .fontWeight(.bold)
                                .frame(maxWidth: 300)
                                .padding()
                                .foregroundColor(.white)
                                .background(canSave ? Color.accentGreen : Color.gray)
                                .cornerRadius(15)
                                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 3)
                        }
                        .disabled(!canSave)
                        .buttonStyle(PressableButtonStyle())
                        .frame(maxWidth: .infinity)
                        .padding(.bottom, 30)
                    }
                    // caps how wide the form gets on ipad's larger screen
                    .frame(maxWidth: 600)
                    .frame(maxWidth: .infinity)
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(.black.opacity(0.8))
                }
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("Done") {
                        titleFieldIsFocused = false
                    }
                }
            }
            .presentationDetents([.large])
        }
    }
}

#Preview {
    AddReminderView(reminderStore: ReminderStore())
        .environmentObject(SettingsStore())
}
