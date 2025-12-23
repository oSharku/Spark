//
//  ClassesView.swift
//  Spark
//
//  Classes view showing enrolled courses
//

import SwiftUI

// MARK: - Classes View
struct ClassesView: View {
    
    @State private var searchText: String = ""
    @State private var selectedSemester: String = "Fall 2025"
    @State private var showClassDetail: Bool = false
    @State private var selectedCourse: CourseData? = nil
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ZStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 24) {
                    ClassesHeaderSection(selectedSemester: $selectedSemester)
                    ClassesSearchBar(searchText: $searchText)
                    ClassesStatsOverview()
                    MyClassesSection(showClassDetail: $showClassDetail, selectedCourse: $selectedCourse)
                    ClassesRecentFilesSection()
                    Color.clear.frame(height: 100)
                }
                .padding(.horizontal, 20)
            }
            
            if showClassDetail, let course = selectedCourse {
                ClassDetailView(isPresented: $showClassDetail, course: course)
                    .transition(.move(edge: .trailing))
            }
        }
        .animation(.easeInOut(duration: 0.3), value: showClassDetail)
    }
}

// MARK: - Classes Header Section
struct ClassesHeaderSection: View {
    @Binding var selectedSemester: String
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Classes")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundStyle(colorScheme == .dark ? .white : .primary)
                
                Menu {
                    Button("Fall 2025") { selectedSemester = "Fall 2025" }
                    Button("Spring 2025") { selectedSemester = "Spring 2025" }
                    Button("Fall 2024") { selectedSemester = "Fall 2024" }
                } label: {
                    HStack(spacing: 6) {
                        Text(selectedSemester)
                            .font(.system(size: 15, weight: .medium))
                        Image(systemName: "chevron.down")
                            .font(.system(size: 11, weight: .semibold))
                    }
                    .foregroundStyle(.blue)
                }
            }
            
            Spacer()
            
            Button(action: {}) {
                Image(systemName: "plus")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundStyle(.white)
                    .frame(width: 44, height: 44)
                    .background(RoundedRectangle(cornerRadius: 14).fill(Color.blue).shadow(color: Color.blue.opacity(0.4), radius: 12, x: 0, y: 6))
            }
        }
        .padding(.top, 8)
    }
}

// MARK: - Classes Search Bar
struct ClassesSearchBar: View {
    @Binding var searchText: String
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(.secondary)
            
            TextField("Search classes, materials...", text: $searchText)
                .font(.system(size: 15))
            
            if !searchText.isEmpty {
                Button(action: { searchText = "" }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 18))
                        .foregroundStyle(.gray.opacity(0.5))
                }
            }
        }
        .padding(14)
        .background(RoundedRectangle(cornerRadius: 16).fill(.ultraThinMaterial))
    }
}

// MARK: - Classes Stats Overview
struct ClassesStatsOverview: View {
    var body: some View {
        HStack(spacing: 12) {
            ClassesStatCard(icon: "book.fill", value: "5", label: "Classes", color: .blue)
            ClassesStatCard(icon: "doc.text.fill", value: "7", label: "Pending", color: .orange)
            ClassesStatCard(icon: "folder.fill", value: "12", label: "New Files", color: .purple)
        }
    }
}

// MARK: - Classes Stat Card
struct ClassesStatCard: View {
    let icon: String
    let value: String
    let label: String
    let color: Color
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundStyle(color)
            
            Text(value)
                .font(.system(size: 24, weight: .bold, design: .rounded))
                .foregroundStyle(colorScheme == .dark ? .white : .primary)
            
            Text(label)
                .font(.system(size: 12))
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(RoundedRectangle(cornerRadius: 18).fill(.ultraThinMaterial))
    }
}

// MARK: - My Classes Section
struct MyClassesSection: View {
    @Binding var showClassDetail: Bool
    @Binding var selectedCourse: CourseData?
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("My Classes")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundStyle(colorScheme == .dark ? .white : .primary)
                Spacer()
                Button("See all") {}
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(.blue)
            }
            
            VStack(spacing: 14) {
                ClassesCardItem(name: "Human-Computer Interaction", code: "CSC 3104", professor: "Prof. Emmet", schedule: "Mon, Wed • 10:00 AM", room: "Room 301", color: Color(hex: "9B59B6"), icon: "laptopcomputer", pendingCount: 2, newFilesCount: 3, progress: 0.75, showClassDetail: $showClassDetail, selectedCourse: $selectedCourse)
                
                ClassesCardItem(name: "Web Development", code: "CSC 2201", professor: "Dr. Parker", schedule: "Tue, Thu • 2:00 PM", room: "Computer Lab A", color: Color(hex: "E67E22"), icon: "globe", pendingCount: 1, newFilesCount: 1, progress: 0.60, showClassDetail: $showClassDetail, selectedCourse: $selectedCourse)
                
                ClassesCardItem(name: "Database Systems", code: "CSC 2105", professor: "Dr. Smith", schedule: "Wed, Fri • 9:00 AM", room: "Room 205", color: Color(hex: "27AE60"), icon: "cylinder.split.1x2", pendingCount: 0, newFilesCount: 2, progress: 0.85, showClassDetail: $showClassDetail, selectedCourse: $selectedCourse)
                
                ClassesCardItem(name: "Software Engineering", code: "CSC 3201", professor: "Prof. Johnson", schedule: "Mon, Thu • 11:00 AM", room: "Room 401", color: Color(hex: "3498DB"), icon: "gearshape.2", pendingCount: 3, newFilesCount: 0, progress: 0.50, showClassDetail: $showClassDetail, selectedCourse: $selectedCourse)
                
                ClassesCardItem(name: "Mobile App Development", code: "CSC 3105", professor: "Dr. Lee", schedule: "Tue, Fri • 3:00 PM", room: "Lab B", color: Color(hex: "E74C3C"), icon: "iphone", pendingCount: 1, newFilesCount: 4, progress: 0.40, showClassDetail: $showClassDetail, selectedCourse: $selectedCourse)
            }
        }
        .padding(20)
        .background(RoundedRectangle(cornerRadius: 24).fill(.ultraThinMaterial))
    }
}

// MARK: - Classes Card Item
struct ClassesCardItem: View {
    let name: String
    let code: String
    let professor: String
    let schedule: String
    let room: String
    let color: Color
    let icon: String
    let pendingCount: Int
    let newFilesCount: Int
    let progress: Double
    @Binding var showClassDetail: Bool
    @Binding var selectedCourse: CourseData?
    
    @State private var isPressed: Bool = false
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(spacing: 14) {
            HStack(spacing: 14) {
                RoundedRectangle(cornerRadius: 14)
                    .fill(color.opacity(0.15))
                    .frame(width: 52, height: 52)
                    .overlay(Image(systemName: icon).font(.system(size: 22)).foregroundStyle(color))
                
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(name)
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundStyle(colorScheme == .dark ? .white : .primary)
                            .lineLimit(1)
                        Spacer()
                        Text(code)
                            .font(.system(size: 11, weight: .medium))
                            .foregroundStyle(.secondary)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Capsule().fill(colorScheme == .dark ? Color.white.opacity(0.1) : Color.gray.opacity(0.1)))
                    }
                    
                    HStack(spacing: 4) {
                        Image(systemName: "person.fill").font(.system(size: 10))
                        Text(professor).font(.system(size: 13))
                    }
                    .foregroundStyle(.secondary)
                }
            }
            
            HStack(spacing: 16) {
                HStack(spacing: 6) {
                    Image(systemName: "clock").font(.system(size: 11))
                    Text(schedule).font(.system(size: 12))
                }
                .foregroundStyle(.secondary)
                
                HStack(spacing: 6) {
                    Image(systemName: "location").font(.system(size: 11))
                    Text(room).font(.system(size: 12))
                }
                .foregroundStyle(.secondary)
                
                Spacer()
            }
            
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 3)
                        .fill(colorScheme == .dark ? Color.white.opacity(0.15) : Color.gray.opacity(0.15))
                        .frame(height: 6)
                    RoundedRectangle(cornerRadius: 3)
                        .fill(color)
                        .frame(width: geo.size.width * progress, height: 6)
                }
            }
            .frame(height: 6)
            
            HStack(spacing: 16) {
                HStack(spacing: 6) {
                    Circle().fill(pendingCount > 0 ? Color.orange : Color.gray.opacity(0.3)).frame(width: 8, height: 8)
                    Text("\(pendingCount) pending").font(.system(size: 12, weight: .medium)).foregroundStyle(pendingCount > 0 ? .orange : .secondary)
                }
                
                HStack(spacing: 6) {
                    Circle().fill(newFilesCount > 0 ? Color.blue : Color.gray.opacity(0.3)).frame(width: 8, height: 8)
                    Text("\(newFilesCount) new files").font(.system(size: 12, weight: .medium)).foregroundStyle(newFilesCount > 0 ? .blue : .secondary)
                }
                
                Spacer()
                
                Text("\(Int(progress * 100))%").font(.system(size: 12, weight: .bold)).foregroundStyle(color)
                Image(systemName: "chevron.right").font(.system(size: 12, weight: .medium)).foregroundStyle(.gray.opacity(0.5))
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(colorScheme == .dark ? Color.white.opacity(0.06) : Color.white.opacity(0.6))
                .shadow(color: .black.opacity(colorScheme == .dark ? 0.2 : 0.04), radius: 8, x: 0, y: 4)
        )
        .overlay(RoundedRectangle(cornerRadius: 18).stroke(color.opacity(0.2), lineWidth: 1))
        .scaleEffect(isPressed ? 0.98 : 1.0)
        .onTapGesture {
            withAnimation(.spring(response: 0.2)) { isPressed = true }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.spring(response: 0.2)) { isPressed = false }
                selectedCourse = CourseData.fromClassCard(name: name, code: code, professor: professor, color: color, icon: icon)
                withAnimation(.easeInOut(duration: 0.3)) { showClassDetail = true }
            }
        }
    }
}

// MARK: - Classes Recent Files Section
struct ClassesRecentFilesSection: View {
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Recent Files")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundStyle(colorScheme == .dark ? .white : .primary)
                Spacer()
                Button("View all") {}
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(.blue)
            }
            
            VStack(spacing: 10) {
                ClassesRecentFileItem(name: "Chapter 5 Notes.pdf", course: "Web Development", uploadedAt: "2 hours ago", size: "2.4 MB", color: Color(hex: "E67E22"))
                ClassesRecentFileItem(name: "AR Project Guidelines.pdf", course: "Human-Computer Interaction", uploadedAt: "Yesterday", size: "1.8 MB", color: Color(hex: "9B59B6"))
                ClassesRecentFileItem(name: "Database Schema.sql", course: "Database Systems", uploadedAt: "2 days ago", size: "45 KB", color: Color(hex: "27AE60"))
            }
        }
        .padding(20)
        .background(RoundedRectangle(cornerRadius: 24).fill(.ultraThinMaterial))
    }
}

// MARK: - Classes Recent File Item
struct ClassesRecentFileItem: View {
    let name: String
    let course: String
    let uploadedAt: String
    let size: String
    let color: Color
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        HStack(spacing: 14) {
            RoundedRectangle(cornerRadius: 10)
                .fill(color.opacity(0.15))
                .frame(width: 44, height: 44)
                .overlay(Image(systemName: "doc.fill").font(.system(size: 18)).foregroundStyle(color))
            
            VStack(alignment: .leading, spacing: 4) {
                Text(name)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(colorScheme == .dark ? .white : .primary)
                    .lineLimit(1)
                
                HStack(spacing: 4) {
                    Text(course).font(.system(size: 12))
                    Text("•").font(.system(size: 12))
                    Text(uploadedAt).font(.system(size: 12))
                }
                .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text(size).font(.system(size: 11, weight: .medium)).foregroundStyle(.secondary)
                Image(systemName: "arrow.down.circle").font(.system(size: 18)).foregroundStyle(.blue)
            }
        }
        .padding(12)
        .background(RoundedRectangle(cornerRadius: 14).fill(colorScheme == .dark ? Color.white.opacity(0.04) : Color.white.opacity(0.5)))
    }
}

#Preview {
    ClassesView()
}
