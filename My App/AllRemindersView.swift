//
//  AllRemindersView.swift
//  My App
//
//  Created by Kailey Liou on 8/24/25.
//

import SwiftUI

struct AllRemindersView: View {
    @Binding var reminders: [Reminder]
    @State private var filterSelection: ReminderFilter = .upcoming
    @State private var searchText = ""
    
    enum ReminderFilter: String, CaseIterable, Identifiable {
        case upcoming = "Upcoming"
        case past = "Past"
        case all = "All"
        
        var id: String { self.rawValue }
    }
    
    var filteredReminders: [Reminder] {
        switch filterSelection {
        case .upcoming:
            return reminders.filter { $0.date >= Calendar.current.startOfDay(for: Date()) }
        case .past:
            return reminders.filter { $0.date < Calendar.current.startOfDay(for: Date()) }
        case .all:
            return reminders
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                Picker("Filter", selection: $filterSelection) {
                    ForEach(ReminderFilter.allCases) { filter in
                        Text(filter.rawValue).tag(filter)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)
                
                Group {
                    if reminders.isEmpty {
                        Text("No reminders found")
                            .foregroundColor(.gray)
                            .italic()
                            .padding()
                    } else {
                        List {
                            ForEach(reminders) { reminder in
                                VStack(alignment: .leading) {
                                    Text(reminder.title)
                                        .font(.headline)
                                    Text(reminder.date.formatted(date: .long, time: .omitted))
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                    Text(reminder.type)
                                        .font(.caption)
                                        .foregroundColor(.blue)
                                }
                                .padding(.vertical, 4)
                            }
                            .onDelete(perform: deleteReminder)
                        }
                        .listStyle(PlainListStyle())
                    }
                }
                .navigationTitle("All Reminders")
                .searchable(text: $searchText, prompt: "Search by title or type")
                
            }
            
        }
    }
    func deleteReminder(at offsets: IndexSet) {
        reminders.remove(atOffsets: offsets)
    }
}

struct AllRemindersView_Previews: PreviewProvider {
    static var previews: some View {
        AllRemindersView(reminders: .constant([]))
    }
}
