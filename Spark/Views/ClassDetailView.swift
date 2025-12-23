//
//  ClassDetailView.swift
//  Spark
//
//  Detailed view for individual class/course showing tasks, resources, announcements
//

import SwiftUI

// MARK: - Course Data Model
struct CourseData: Identifiable {
    let id: UUID
    let name: String
    let code: String
    let lecturerName: String
    let semester: String
    let studentCount: Int
    let courseCode: String
    let color: Color
    let icon: String
    let openTasks: Int
    let resourceCount: Int
    let upcomingTask: String
    let dueSoonCount: Int
    let needsUploadCount: Int
    let labName: String
    let commentCount: Int
    let unresolvedCount: Int
    let announcements: [ClassAnnouncement]
    
    static func fromClassCard(
        name: String,
        code: String,
        professor: String,
        color: Color,
        icon: String
    ) -> CourseData {
        CourseData(
            id: UUID(),
            name: name,
            code: code,
            lecturerName: professor,
            semester: "Fall 2025",
            studentCount: Int.random(in: 30...60),
            courseCode: "\(code)-FA25-A",
            color: color,
            icon: icon,
            openTasks: Int.random(in: 1...5),
            resourceCount: Int.random(in: 5...15),
            upcomingTask: "Lab \(Int.random(in: 3...8)) · Due Sat",
            dueSoonCount: Int.random(in: 1...4),
            needsUploadCount: Int.random(in: 0...2),
            labName: "Lab \(Int.random(in: 3...8))",
            commentCount: Int.random(in: 10...30),
            unresolvedCount: Int.random(in: 1...5),
            announcements: [
                ClassAnnouncement(
                    authorName: professor,
                    content: "Midterm review materials have been uploaded to Resources. Please review before the exam.",
                    timeAgo: "\(Int.random(in: 1...12))h ago",
                    commentCount: Int.random(in: 10...30),
                    isPinned: true
                ),
                ClassAnnouncement(
                    authorName: professor,
                    content: "Office hours have been extended this week. Feel free to drop by with any questions.",
                    timeAgo: "1d ago",
                    commentCount: Int.random(in: 5...15),
                    isPinned: false
                )
            ]
        )
    }
}

// MARK: - Class Announcement Model
struct ClassAnnouncement: Identifiable {
    let id = UUID()
    let authorName: String
    let content: String
    let timeAgo: String
    let commentCount: Int
    let isPinned: Bool
}

// MARK: - Class Detail View
struct ClassDetailView: View {
    
    @Binding var isPresented: Bool
    let course: CourseData
    @Environment(\.colorScheme) var colorScheme
    
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
                        courseInfoCard
                        quickActionButtons
                        statsRow
                        announcementsSection
                        discussionSection
                        Color.clear.frame(height: 40)
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 16)
                }
            }
        }
    }
    
    private var backgroundGradient: some View {
        Group {
            if colorScheme == .dark {
                LinearGradient(colors: [Color(hex: "1C1C1E"), Color(hex: "2C2C2E"), Color(hex: "1C1C1E")], startPoint: .top, endPoint: .bottom)
            } else {
                LinearGradient(colors: [Color(hex: "E8F4FD"), Color(hex: "B8D4E8"), Color(hex: "7EB8DA")], startPoint: .top, endPoint: .bottom)
            }
        }
    }
    
    private var navigationHeader: some View {
        HStack(spacing: 12) {
            Button(action: { withAnimation(.easeInOut(duration: 0.3)) { isPresented = false } }) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(.blue)
            }
            
            HStack(spacing: 10) {
                Circle()
                    .fill(course.color.opacity(0.15))
                    .frame(width: 36, height: 36)
                    .overlay(Image(systemName: course.icon).font(.system(size: 16)).foregroundStyle(course.color))
                
                Text("\(course.code) · \(course.name)")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(colorScheme == .dark ? .white : .primary)
                    .lineLimit(1)
            }
            
            Spacer()
            
            Button(action: {}) {
                Image(systemName: "line.3.horizontal")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundStyle(colorScheme == .dark ? .white : .primary)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .background(Rectangle().fill(.ultraThinMaterial).shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2))
    }
    
    private var courseInfoCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text(course.semester)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(Capsule().fill(colorScheme == .dark ? Color.white.opacity(0.1) : Color.gray.opacity(0.15)))
                Spacer()
            }
            
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("\(course.code) · \(course.name)")
                        .font(.system(size: 22, weight: .bold))
                        .foregroundStyle(colorScheme == .dark ? .white : .primary)
                    
                    HStack(spacing: 4) {
                        Text("Instructor:").foregroundStyle(.secondary)
                        Text(course.lecturerName).foregroundStyle(colorScheme == .dark ? .white : .primary)
                        Text("·").foregroundStyle(.secondary)
                        Text("\(course.studentCount) students").foregroundStyle(.secondary)
                    }
                    .font(.system(size: 13))
                    
                    HStack(spacing: 4) {
                        Text("Code:").foregroundStyle(.secondary)
                        Text(course.courseCode).foregroundStyle(colorScheme == .dark ? .white : .primary)
                    }
                    .font(.system(size: 13))
                }
                
                Spacer()
                
                VStack(spacing: 8) {
                    DetailActionButton(title: "Schedule", icon: "calendar", color: .blue)
                    DetailActionButton(title: "Class chat", icon: "bubble.left.and.bubble.right", color: .blue)
                }
            }
        }
        .padding(20)
        .background(RoundedRectangle(cornerRadius: 20).fill(colorScheme == .dark ? Color(hex: "2C2C2E") : .white).shadow(color: .black.opacity(0.08), radius: 15, x: 0, y: 8))
    }
    
    private var quickActionButtons: some View {
        VStack(spacing: 12) {
            HStack(spacing: 12) {
                DetailQuickCard(title: "Open tasks", icon: "checkmark.circle", count: course.openTasks)
                DetailQuickCard(title: "Open resources", icon: "folder", count: course.resourceCount)
            }
            HStack(spacing: 12) {
                DetailQuickCard(title: "My grades", icon: "chart.bar", count: nil, showArrow: true)
                DetailQuickCard(title: "Upload submission", icon: "arrow.up.doc", count: nil, showArrow: true)
            }
        }
    }
    
    private var statsRow: some View {
        HStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 6) {
                HStack(spacing: 6) {
                    Circle().fill(Color.orange).frame(width: 8, height: 8)
                    Text("Upcoming").font(.system(size: 13, weight: .medium)).foregroundStyle(.secondary)
                }
                Text(course.upcomingTask).font(.system(size: 14, weight: .semibold)).foregroundStyle(colorScheme == .dark ? .white : .primary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(14)
            .background(RoundedRectangle(cornerRadius: 14).fill(colorScheme == .dark ? Color.white.opacity(0.06) : Color.orange.opacity(0.1)))
            
            VStack(alignment: .leading, spacing: 6) {
                HStack(spacing: 6) {
                    Circle().fill(Color.blue).frame(width: 8, height: 8)
                    Text("To-do").font(.system(size: 13, weight: .medium)).foregroundStyle(.secondary)
                }
                VStack(alignment: .leading, spacing: 2) {
                    Text("\(course.dueSoonCount) due soon · \(course.needsUploadCount)").font(.system(size: 14, weight: .semibold)).foregroundStyle(colorScheme == .dark ? .white : .primary)
                    Text("needs upload").font(.system(size: 12)).foregroundStyle(.secondary)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(14)
            .background(RoundedRectangle(cornerRadius: 14).fill(colorScheme == .dark ? Color.white.opacity(0.06) : Color.blue.opacity(0.1)))
        }
    }
    
    private var announcementsSection: some View {
        VStack(spacing: 0) {
            ForEach(course.announcements) { announcement in
                DetailAnnouncementCard(announcement: announcement)
                if announcement.id != course.announcements.last?.id {
                    Divider().padding(.horizontal, 16)
                }
            }
        }
        .background(RoundedRectangle(cornerRadius: 20).fill(colorScheme == .dark ? Color(hex: "2C2C2E") : .white).shadow(color: .black.opacity(0.08), radius: 15, x: 0, y: 8))
    }
    
    private var discussionSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Text("Student Q&A · \(course.labName)").font(.system(size: 16, weight: .bold)).foregroundStyle(colorScheme == .dark ? .white : .primary)
                Spacer()
                Text("Live").font(.system(size: 11, weight: .semibold)).foregroundStyle(.white).padding(.horizontal, 10).padding(.vertical, 4).background(Capsule().fill(Color.green))
            }
            
            Text("Office hours today 3:00–4:00 PM. Drop questions below.").font(.system(size: 14)).foregroundStyle(.secondary)
            
            HStack(spacing: 4) {
                Text("\(course.commentCount) comments").foregroundStyle(.secondary)
                Text("·").foregroundStyle(.secondary)
                Text("\(course.unresolvedCount) unresolved").foregroundStyle(.orange)
            }
            .font(.system(size: 13))
            
            HStack(spacing: 12) {
                Button(action: {}) {
                    HStack(spacing: 6) {
                        Image(systemName: "bubble.left").font(.system(size: 14))
                        Text("Open thread").font(.system(size: 14, weight: .medium))
                    }
                    .foregroundStyle(colorScheme == .dark ? .white : .primary)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .background(RoundedRectangle(cornerRadius: 10).stroke(colorScheme == .dark ? Color.white.opacity(0.2) : Color.gray.opacity(0.3), lineWidth: 1))
                }
                
                Button(action: {}) {
                    HStack(spacing: 6) {
                        Image(systemName: "bell").font(.system(size: 14))
                        Text("Set reminder").font(.system(size: 14, weight: .medium))
                    }
                    .foregroundStyle(colorScheme == .dark ? .white : .primary)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .background(RoundedRectangle(cornerRadius: 10).stroke(colorScheme == .dark ? Color.white.opacity(0.2) : Color.gray.opacity(0.3), lineWidth: 1))
                }
                Spacer()
            }
        }
        .padding(20)
        .background(RoundedRectangle(cornerRadius: 20).fill(colorScheme == .dark ? Color(hex: "2C2C2E") : .white).shadow(color: .black.opacity(0.08), radius: 15, x: 0, y: 8))
    }
}

// MARK: - Supporting Views
struct DetailActionButton: View {
    let title: String
    let icon: String
    let color: Color
    
    var body: some View {
        Button(action: {}) {
            HStack(spacing: 6) {
                Image(systemName: icon).font(.system(size: 12))
                Text(title).font(.system(size: 12, weight: .medium))
            }
            .foregroundStyle(.white)
            .padding(.horizontal, 14)
            .padding(.vertical, 8)
            .background(RoundedRectangle(cornerRadius: 8).fill(color))
        }
    }
}

struct DetailQuickCard: View {
    let title: String
    let icon: String
    var count: Int? = nil
    var showArrow: Bool = false
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        Button(action: {}) {
            HStack {
                Image(systemName: icon).font(.system(size: 16)).foregroundStyle(.secondary)
                Text(title).font(.system(size: 14, weight: .medium)).foregroundStyle(colorScheme == .dark ? .white : .primary)
                Spacer()
                if let count = count {
                    Text("\(count)").font(.system(size: 14, weight: .semibold)).foregroundStyle(.blue)
                }
                if showArrow {
                    Image(systemName: "chevron.right").font(.system(size: 12, weight: .medium)).foregroundStyle(.secondary)
                }
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(colorScheme == .dark ? Color.white.opacity(0.15) : Color.gray.opacity(0.2), lineWidth: 1)
                    .background(RoundedRectangle(cornerRadius: 14).fill(colorScheme == .dark ? Color.white.opacity(0.04) : Color.white.opacity(0.6)))
            )
        }
        .buttonStyle(.plain)
    }
}

struct DetailAnnouncementCard: View {
    let announcement: ClassAnnouncement
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(announcement.authorName).font(.system(size: 15, weight: .semibold)).foregroundStyle(colorScheme == .dark ? .white : .primary)
                Text("posted an announcement").font(.system(size: 15)).foregroundStyle(.secondary)
                Spacer()
                if announcement.isPinned {
                    Text("Pinned").font(.system(size: 11, weight: .medium)).foregroundStyle(.blue).padding(.horizontal, 10).padding(.vertical, 4).background(Capsule().fill(Color.blue.opacity(0.15)))
                }
            }
            
            Text(announcement.content).font(.system(size: 14)).foregroundStyle(colorScheme == .dark ? .white.opacity(0.9) : .primary.opacity(0.8)).lineLimit(3)
            
            HStack {
                Text("Posted \(announcement.timeAgo)").font(.system(size: 12)).foregroundStyle(.secondary)
                Text("·").foregroundStyle(.secondary)
                Text("\(announcement.commentCount) comments").font(.system(size: 12)).foregroundStyle(.secondary)
                Spacer()
            }
            
            HStack(spacing: 12) {
                Button(action: {}) {
                    HStack(spacing: 6) {
                        Image(systemName: "bubble.left").font(.system(size: 13))
                        Text("Add comment").font(.system(size: 13, weight: .medium))
                    }
                    .foregroundStyle(colorScheme == .dark ? .white : .primary)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 8)
                    .background(RoundedRectangle(cornerRadius: 8).stroke(colorScheme == .dark ? Color.white.opacity(0.2) : Color.gray.opacity(0.3), lineWidth: 1))
                }
                
                Button(action: {}) {
                    HStack(spacing: 6) {
                        Image(systemName: "checkmark.circle").font(.system(size: 13))
                        Text("Mark read").font(.system(size: 13, weight: .medium))
                    }
                    .foregroundStyle(colorScheme == .dark ? .white : .primary)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 8)
                    .background(RoundedRectangle(cornerRadius: 8).stroke(colorScheme == .dark ? Color.white.opacity(0.2) : Color.gray.opacity(0.3), lineWidth: 1))
                }
                Spacer()
            }
        }
        .padding(20)
    }
}

#Preview {
    ClassDetailView(isPresented: .constant(true), course: CourseData.fromClassCard(name: "Data Structures", code: "CS201", professor: "Dr. Parker", color: .blue, icon: "square.stack.3d.up"))
}
