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

    // if this is set, the form is editing an existing reminder instead of
    // creating a new one. nil means "new reminder" (the original behavior)
    var editingReminder: Reminder?

    @State private var title: String
    @State private var date: Date
    @State private var type: String
    @FocusState private var titleFieldIsFocused: Bool

    init(reminderStore: ReminderStore, editingReminder: Reminder? = nil) {
        self.reminderStore = reminderStore
        self.editingReminder = editingReminder
        _title = State(initialValue: editingReminder?.title ?? "")
        _date = State(initialValue: editingReminder?.date ?? Date())
        _type = State(initialValue: editingReminder?.type ?? "Vaccine")
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
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(20)
                        .shadow(color: .black.opacity(0.1), radius: 6, x: 0, y: 3)
                        .padding(.horizontal)
                        
                        Spacer(minLength: 20)
                        
                        Button(action: {
                            if let existing = editingReminder {
                                // editing: cancel whatever was scheduled under the old date,
                                // swap the reminder in place (keeping its original id and
                                // isGenerated flag), then reschedule under the new details
                                NotificationManager.cancelNotification(for: existing)
                                let updated = Reminder(id: existing.id, title: title, date: date, type: type, isGenerated: existing.isGenerated)
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
                                let newReminder = Reminder(title: title, date: date, type: type, isGenerated: false)
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
                    // caps how wide the form gets on ipad's larger screen, same
                    // pattern used on the other main screens
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
            // on ipad, .sheet() defaults to a smaller floating panel instead of
            // full screen like iphone gets automatically. forcing the large
            // detent makes it take the full height on both instead of clipping
            // the form's content inside a too-small panel
            .presentationDetents([.large])
        }
    }
}

#Preview {
    AddReminderView(reminderStore: ReminderStore())
        .environmentObject(SettingsStore())
}
