//
//  ProfileView.swift
//  My App
//
//  Created by Kailey Liou on 10/26/25.
//

import SwiftUI

struct ProfileView: View {
    @Binding var profile: Profile
    @Environment(\.dismiss) var dismiss

    @State private var name = ""
    @State private var dateOfBirth = Date()
    @State private var gender = ""
    @State private var conditions: [String] = []
    @State private var newCondition = ""
    @State private var familyHistory: String = ""

    var canSave: Bool {
        !name.trimmingCharacters(in: .whitespaces).isEmpty &&
        dateOfBirth <= Date()
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {

                    Text("Profile")
                        .font(.system(size: 28, weight: .semibold, design: .rounded))
                        .foregroundColor(.black.opacity(0.8))

                    VStack(alignment: .leading, spacing: 10) {
                        Text("Basic Info")
                            .font(.headline)

                        TextField("Name", text: $name)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(10)
                            .shadow(color: .black.opacity(0.05), radius: 3, x: 0, y: 2)

                        DatePicker("Date of Birth", selection: $dateOfBirth, displayedComponents: .date)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(10)
                            .shadow(color: .black.opacity(0.05), radius: 3, x: 0, y: 2)

                        Picker("Gender", selection: $gender) {
                            Text("Male").tag("Male")
                            Text("Female").tag("Female")
                            Text("Other").tag("Other")
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(color: .black.opacity(0.05), radius: 3, x: 0, y: 2)
                    }

                    VStack(alignment: .leading, spacing: 10) {
                        Text("Medical Conditions")
                            .font(.headline)

                        FlexibleView(data: conditions, spacing: 8) { condition in
                            HStack(spacing: 4) {
                                Text(condition)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(Color.accentGreen.opacity(0.2))
                                    .cornerRadius(8)

                                Button(action: {
                                    if let index = conditions.firstIndex(of: condition) {
                                        conditions.remove(at: index)
                                    }
                                }) {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundColor(.gray)
                                        .font(.caption)
                                }
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)

                        HStack(spacing: 8) {
                            TextField("Add condition", text: $newCondition)
                                .font(.system(size: 16, weight: .regular, design: .rounded))
                                .foregroundColor(.black)
                                .padding(12)
                                .background(Color.white)
                                .cornerRadius(10)
                                .shadow(color: .black.opacity(0.05), radius: 3, x: 0, y: 2)

                            Button(action: {
                                let trimmed = newCondition.trimmingCharacters(in: .whitespaces)
                                guard !trimmed.isEmpty && !conditions.contains(trimmed) else { return }
                                conditions.append(trimmed)
                                newCondition = ""
                            }) {
                                Image(systemName: "plus.circle.fill")
                                    .foregroundColor(.accentGreen)
                                    .font(.title2)
                            }
                        }
                    }

                    VStack(alignment: .leading, spacing: 10) {
                        Text("Family History")
                            .font(.headline)
                        TextEditor(text: $familyHistory)
                            .frame(height: 80)
                            .padding(8)
                            .background(Color.white)
                            .cornerRadius(10)
                            .shadow(color: .black.opacity(0.05), radius: 3, x: 0, y: 2)
                    }

                    Button(action: {
                        profile.name = name
                        profile.dateOfBirth = dateOfBirth
                        profile.gender = gender
                        profile.conditions = conditions
                        profile.familyHistory = familyHistory
                        dismiss()
                    }) {
                        Text("Save Profile")
                            .fontWeight(.bold)
                            .frame(maxWidth: 300)
                            .padding()
                            .foregroundColor(.white)
                            .background(canSave ? Color.accentGreen : Color.gray)
                            .cornerRadius(12)
                            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 3)
                    }
                    .disabled(!canSave)
                    .frame(maxWidth: .infinity)

                }
                .padding()
            }
            .background(Color.background)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            .onAppear {
                name = profile.name
                dateOfBirth = profile.dateOfBirth
                gender = profile.gender
                conditions = profile.conditions
                familyHistory = profile.familyHistory
            }
        }
    }
}

#Preview {
    ProfileView(profile: .constant(Profile(name: "", dateOfBirth: Date(), gender: "", conditions: [], familyHistory: "")))
}
