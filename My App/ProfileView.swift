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
    @State private var familyHistory: String = ""
    
    var canSave: Bool {
        !name.trimmingCharacters(in: .whitespaces).isEmpty &&
        dateOfBirth <= Date()
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    
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
                        Text("Medical Info")
                            .font(.headline)
                        TextEditor(text: Binding(
                            get: { conditions.joined(separator: ", ") },
                            set: { conditions = $0.components(separatedBy: ", ").filter { !$0.isEmpty } }
                        ))
                        .frame(height: 80)
                        .padding(8)
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(color: .black.opacity(0.05), radius: 3, x: 0, y: 2)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray.opacity(0.2))
                        )
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
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.gray.opacity(0.2))
                            )
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
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(canSave ? Color(red: 0.40, green: 0.50, blue: 0.35) : Color.gray)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                    }
                    .disabled(!canSave)
                    
                }
                .padding()
            }
            .background(Color(red: 0.97, green: 0.96, blue: 0.92))
            .navigationTitle("Profile")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark")
                            .foregroundColor(.black)
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
