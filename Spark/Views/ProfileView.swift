//
//  ProfileView.swift
//  Spark
//
//  Profile view displaying student information and academic details
//

import SwiftUI

// MARK: - Profile View
struct ProfileView: View {
    
    // MARK: - Properties
    @Binding var isPresented: Bool
    @StateObject private var appState = AppState.shared
    @Environment(\.colorScheme) var colorScheme
    @State private var isEditing: Bool = false
    
    // MARK: - Body
    var body: some View {
        ZStack {
            // Background
            backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Navigation Header
                navigationHeader
                
                // Scrollable Content
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 20) {
                        // Profile Card
                        profileCard
                        
                        // Academic Info Card
                        academicInfoCard
                        
                        // Security Notice
                        securityNotice
                        
                        // Bottom spacing
                        Color.clear.frame(height: 40)
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 16)
                }
            }
        }
    }
    
    // MARK: - Background Gradient
    private var backgroundGradient: some View {
        Group {
            if colorScheme == .dark {
                LinearGradient(
                    colors: [
                        Color(hex: "1C1C1E"),
                        Color(hex: "2C2C2E"),
                        Color(hex: "1C1C1E")
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
            } else {
                LinearGradient(
                    colors: [
                        Color(hex: "2A9D8F"),
                        Color(hex: "287271"),
                        Color(hex: "1D5C5C")
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
            }
        }
    }
    
    // MARK: - Navigation Header
    private var navigationHeader: some View {
        HStack(spacing: 16) {
            // Back Button
            Button(action: {
                withAnimation(.easeInOut(duration: 0.3)) {
                    isPresented = false
                }
            }) {
                Image(systemName: "arrow.left")
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundStyle(.white)
            }
            
            // Title
            Text("Profile")
                .font(.system(size: 32, weight: .bold))
                .foregroundStyle(.white)
            
            Spacer()
            
            // Edit Button
            Button(action: {
                withAnimation(.spring(response: 0.3)) {
                    isEditing.toggle()
                }
            }) {
                Image(systemName: isEditing ? "checkmark.circle.fill" : "pencil.circle.fill")
                    .font(.system(size: 28))
                    .foregroundStyle(.white.opacity(0.9))
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
    }
    
    // MARK: - Profile Card
    private var profileCard: some View {
        HStack(spacing: 16) {
            // Avatar with Add Button
            ZStack(alignment: .bottomTrailing) {
                // Profile Image
                Circle()
                    .fill(LinearGradient(
                        colors: [Color.gray.opacity(0.3), Color.gray.opacity(0.1)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ))
                    .frame(width: 90, height: 90)
                    .overlay(
                        Image(systemName: "person.fill")
                            .font(.system(size: 40))
                            .foregroundStyle(.gray)
                    )
                    .overlay(
                        Circle()
                            .stroke(Color.blue.opacity(0.5), lineWidth: 3)
                    )
                
                // Add/Edit Photo Button
                Button(action: {}) {
                    Circle()
                        .fill(Color.blue)
                        .frame(width: 28, height: 28)
                        .overlay(
                            Image(systemName: "plus")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundStyle(.white)
                        )
                }
            }
            
            // User Info
            VStack(alignment: .leading, spacing: 4) {
                // Role Badge
                Text("Student")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(.blue)
                
                // Name
                Text(appState.currentUser.name)
                    .font(.system(size: 22, weight: .bold))
                    .foregroundStyle(colorScheme == .dark ? .white : .primary)
                
                // Email
                Text(appState.currentUser.email)
                    .font(.system(size: 13))
                    .foregroundStyle(.secondary)
                
                // Program
                VStack(alignment: .leading, spacing: 2) {
                    Text("Program")
                        .font(.system(size: 12))
                        .foregroundStyle(.secondary)
                    Text(appState.currentUser.program)
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(colorScheme == .dark ? .white : .primary)
                }
                .padding(.top, 4)
                
                // Year / Semester
                VStack(alignment: .leading, spacing: 2) {
                    Text("Year / Semester")
                        .font(.system(size: 12))
                        .foregroundStyle(.secondary)
                    HStack(spacing: 4) {
                        Text("Year \(appState.currentUser.year)")
                            .font(.system(size: 15, weight: .semibold))
                        Text("-")
                            .foregroundStyle(.secondary)
                        Text("Sem \(appState.currentUser.semester)")
                            .font(.system(size: 15, weight: .semibold))
                            .underline()
                    }
                    .foregroundStyle(colorScheme == .dark ? .white : .primary)
                }
                .padding(.top, 2)
            }
            
            Spacer()
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(colorScheme == .dark ? Color(hex: "2C2C2E") : .white)
                .shadow(color: .black.opacity(0.1), radius: 15, x: 0, y: 8)
        )
    }
    
    // MARK: - Academic Info Card
    private var academicInfoCard: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Section Title
            Text("Academic Info")
                .font(.system(size: 22, weight: .bold))
                .foregroundStyle(colorScheme == .dark ? .white : .primary)
            
            // Info Grid
            VStack(spacing: 16) {
                // Row 1: Full Name & Number of Subjects
                HStack(spacing: 16) {
                    InfoField(
                        label: "Full name",
                        value: appState.currentUser.name,
                        isEditing: isEditing
                    )
                    InfoField(
                        label: "Number of subject",
                        value: "\(appState.currentUser.enrolledCourses.count)",
                        isEditing: false
                    )
                }
                
                // Row 2: Student ID & Department
                HStack(spacing: 16) {
                    InfoField(
                        label: "Student ID",
                        value: appState.currentUser.studentId ?? "-",
                        isEditing: false
                    )
                    InfoField(
                        label: "Department",
                        value: appState.currentUser.department,
                        isEditing: false
                    )
                }
                
                // Row 3: Phone & Club
                HStack(spacing: 16) {
                    InfoField(
                        label: "Phone",
                        value: appState.currentUser.phone,
                        isEditing: isEditing
                    )
                    InfoField(
                        label: "Club",
                        value: appState.currentUser.clubs.isEmpty ? "" : appState.currentUser.clubs.joined(separator: ", "),
                        isEditing: false
                    )
                }
                
                // Row 4: Credits & Attendance
                HStack(spacing: 16) {
                    InfoField(
                        label: "Credits",
                        value: "\(appState.currentUser.credits)",
                        isEditing: false
                    )
                    InfoField(
                        label: "Attendance",
                        value: "\(appState.currentUser.attendance)%",
                        isEditing: false
                    )
                }
                
                // Bio Field (Full Width)
                VStack(alignment: .leading, spacing: 8) {
                    Text("Bio")
                        .font(.system(size: 13))
                        .foregroundStyle(.secondary)
                    
                    if isEditing {
                        TextField("Enter your bio...", text: .constant(appState.currentUser.bio), axis: .vertical)
                            .font(.system(size: 15))
                            .padding(14)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(colorScheme == .dark ? Color.white.opacity(0.08) : Color(hex: "F5F9FA"))
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.blue.opacity(0.5), lineWidth: 1)
                            )
                            .lineLimit(3...6)
                    } else {
                        Text(appState.currentUser.bio.isEmpty ? "No bio added" : appState.currentUser.bio)
                            .font(.system(size: 15))
                            .foregroundColor(appState.currentUser.bio.isEmpty ? .secondary : (colorScheme == .dark ? Color.white : Color.primary))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(14)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(colorScheme == .dark ? Color.white.opacity(0.08) : Color(hex: "F5F9FA"))
                            )
                    }
                }
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(colorScheme == .dark ? Color(hex: "2C2C2E") : .white)
                .shadow(color: .black.opacity(0.1), radius: 15, x: 0, y: 8)
        )
    }
    
    // MARK: - Security Notice
    private var securityNotice: some View {
        HStack(spacing: 14) {
            // Icon
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.green.opacity(0.15))
                .frame(width: 50, height: 50)
                .overlay(
                    Image(systemName: "lock.shield.fill")
                        .font(.system(size: 24))
                        .foregroundStyle(.green)
                )
            
            // Text
            VStack(alignment: .leading, spacing: 2) {
                Text("All information are encrypted within")
                    .font(.system(size: 14))
                    .foregroundStyle(.white.opacity(0.8))
                Text("our most secured database")
                    .font(.system(size: 14))
                    .foregroundStyle(.white.opacity(0.8))
            }
            
            Spacer()
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white.opacity(0.1))
        )
    }
}

// MARK: - Info Field Component
struct InfoField: View {
    let label: String
    let value: String
    var isEditing: Bool = false
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(label)
                .font(.system(size: 13))
                .foregroundStyle(.secondary)
            
            if isEditing {
                TextField(label, text: .constant(value))
                    .font(.system(size: 15))
                    .padding(14)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(colorScheme == .dark ? Color.white.opacity(0.08) : Color(hex: "F5F9FA"))
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.blue.opacity(0.5), lineWidth: 1)
                    )
            } else {
                Text(value.isEmpty ? "-" : value)
                    .font(.system(size: 15))
                    .foregroundColor(value.isEmpty ? Color.secondary : (colorScheme == .dark ? Color.white : Color.primary))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(14)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(colorScheme == .dark ? Color.white.opacity(0.08) : Color(hex: "F5F9FA"))
                    )
            }
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - Preview
#Preview {
    ProfileView(isPresented: .constant(true))
}
