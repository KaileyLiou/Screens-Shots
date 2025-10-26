////
////  AllRemindersView.swift
////  My App
////
////  Created by Kailey Liou on 8/24/25.
////
//
//import SwiftUI
//
//struct AllRemindersView: View {
//    @Binding var reminders: [Reminder]
//    @State private var filterSelection: ReminderFilter = .upcoming
//    @State private var searchText = ""
//    
//    enum ReminderFilter: String, CaseIterable, Identifiable {
//        case upcoming = "Upcoming"
//        case past = "Past"
//        case all = "All"
//        
//        var id: String { self.rawValue }
//    }
//    
//    var filteredReminders: [Reminder] {
//        switch filterSelection {
//        case .upcoming:
//            return reminders.filter { $0.date >= Calendar.current.startOfDay(for: Date()) }
//        case .past:
//            return reminders.filter { $0.date < Calendar.current.startOfDay(for: Date()) }
//        case .all:
//            return reminders
//        }
//    }
//    
//    var body: some View {
//        NavigationStack {
//            VStack {
//                Picker("Filter", selection: $filterSelection) {
//                    ForEach(ReminderFilter.allCases) { filter in
//                        Text(filter.rawValue).tag(filter)
//                    }
//                }
//                .pickerStyle(SegmentedPickerStyle())
//                .padding(.horizontal)
//                
//                Group {
//                    if reminders.isEmpty {
//                        Text("No reminders found")
//                            .foregroundColor(.gray)
//                            .italic()
//                            .padding()
//                    } else {
//                        List {
//                            ForEach(reminders) { reminder in
//                                VStack(alignment: .leading) {
//                                    Text(reminder.title)
//                                        .font(.headline)
//                                    Text(reminder.date.formatted(date: .long, time: .omitted))
//                                        .font(.subheadline)
//                                        .foregroundColor(.gray)
//                                    Text(reminder.type)
//                                        .font(.caption)
//                                        .foregroundColor(.blue)
//                                }
//                                .padding(.vertical, 4)
//                            }
//                            .onDelete(perform: deleteReminder)
//                        }
//                        .listStyle(PlainListStyle())
//                    }
//                }
//                .navigationTitle("All Reminders")
//                .searchable(text: $searchText, prompt: "Search by title or type")
//                
//            }
//            
//        }
//    }
//    func deleteReminder(at offsets: IndexSet) {
//        reminders.remove(atOffsets: offsets)
//    }
//}
//
//struct AllRemindersView_Previews: PreviewProvider {
//    static var previews: some View {
//        AllRemindersView(reminders: .constant([]))
//    }
//}

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
        let base = switch filterSelection {
        case .upcoming:
            reminders.filter { $0.date >= Calendar.current.startOfDay(for: Date()) }
        case .past:
            reminders.filter { $0.date < Calendar.current.startOfDay(for: Date()) }
        case .all:
            reminders
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
                // Subtle background to match AddReminderView
                Color(red: 0.97, green: 0.96, blue: 0.92)
                    .ignoresSafeArea()
                
                VStack(spacing: 15) {
                    // Filter picker
                    Picker("Filter", selection: $filterSelection) {
                        ForEach(ReminderFilter.allCases) { filter in
                            Text(filter.rawValue).tag(filter)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(.horizontal)
                    .padding(.top, 10)
                    
                    // Reminder list area
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
                        ScrollView {
                            LazyVStack(spacing: 12) {
                                ForEach(filteredReminders) { reminder in
                                    ReminderCard(reminder: reminder)
                                        .padding(.horizontal)
                                }
                                .onDelete(perform: deleteReminder)
                            }
                            .padding(.vertical)
                        }
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

struct ReminderCard: View {
    let reminder: Reminder
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 6) {
                Text(reminder.title)
                    .font(.headline)
                    .foregroundColor(.black.opacity(0.85))
                
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

struct AllRemindersView_Previews: PreviewProvider {
    static var previews: some View {
        AllRemindersView(reminders: .constant([
            Reminder(title: "Flu Shot", date: .now.addingTimeInterval(86400), type: "Vaccine"),
            Reminder(title: "Mammogram", date: .now.addingTimeInterval(-86400 * 5), type: "Screening")
        ]))
    }
}
