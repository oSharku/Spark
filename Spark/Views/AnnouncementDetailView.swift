//
//  AnnouncementDetailView.swift
//  Spark
//
//  Detailed announcement view with full content
//

import SwiftUI

// MARK: - Announcement Detail View
struct AnnouncementDetailView: View {
    
    let announcement: Announcement
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme
    
    private var timeAgo: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        return formatter.localizedString(for: announcement.createdAt, relativeTo: Date())
    }
    
    var body: some View {
        ZStack {
            // Background
            SparkBackground()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 24) {
                    // Custom Header
                    HStack {
                        Button(action: { dismiss() }) {
                            HStack(spacing: 6) {
                                Image(systemName: "chevron.left")
                                    .font(.system(size: 16, weight: .semibold))
                                Text("Back")
                                    .font(.system(size: 16, weight: .medium))
                            }
                            .foregroundStyle(.blue)
                        }
                        
                        Spacer()
                        
                        Menu {
                            Button(action: {}) {
                                Label("Share", systemImage: "square.and.arrow.up")
                            }
                            Button(action: {}) {
                                Label("Add to Calendar", systemImage: "calendar.badge.plus")
                            }
                            Button(action: {}) {
                                Label("Bookmark", systemImage: "bookmark")
                            }
                            Divider()
                            Button(role: .destructive, action: {}) {
                                Label("Report Issue", systemImage: "exclamationmark.triangle")
                            }
                        } label: {
                            Image(systemName: "ellipsis.circle")
                                .font(.system(size: 20))
                                .foregroundStyle(.blue)
                                .frame(width: 44, height: 44)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 8)
                    
                    // Priority & Category Badge
                    VStack(spacing: 16) {
                        ZStack {
                            Circle()
                                .fill(announcement.priority.color.opacity(0.15))
                                .frame(width: 80, height: 80)
                            
                            Image(systemName: announcement.category.icon)
                                .font(.system(size: 36))
                                .foregroundStyle(announcement.priority.color)
                        }
                        .shadow(color: announcement.priority.color.opacity(0.3), radius: 12, x: 0, y: 6)
                        
                        HStack(spacing: 8) {
                            Text(announcement.priority.rawValue)
                                .font(.system(size: 13, weight: .bold))
                                .foregroundStyle(announcement.priority.color)
                                .padding(.horizontal, 14)
                                .padding(.vertical, 6)
                                .background(
                                    Capsule()
                                        .fill(announcement.priority.color.opacity(0.12))
                                )
                            
                            Text(announcement.category.rawValue)
                                .font(.system(size: 13, weight: .bold))
                                .foregroundStyle(announcement.category.color)
                                .padding(.horizontal, 14)
                                .padding(.vertical, 6)
                                .background(
                                    Capsule()
                                        .fill(announcement.category.color.opacity(0.12))
                                )
                        }
                    }
                    
                    // Main Content Card
                    VStack(alignment: .leading, spacing: 20) {
                        // Author Info
                        HStack(spacing: 12) {
                            Circle()
                                .fill(
                                    LinearGradient(
                                        colors: announcement.authorRole == .lecturer ? [.green.opacity(0.6), .teal.opacity(0.6)] : [.blue.opacity(0.6), .purple.opacity(0.6)],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 50, height: 50)
                                .overlay(
                                    Text(String(announcement.authorName.prefix(1)))
                                        .font(.system(size: 20, weight: .semibold))
                                        .foregroundStyle(.white)
                                )
                                .shadow(color: announcement.authorRole.color.opacity(0.3), radius: 6, x: 0, y: 3)
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text(announcement.authorName)
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundStyle(colorScheme == .dark ? .white : .primary)
                                
                                HStack(spacing: 6) {
                                    Text(announcement.authorRole.rawValue)
                                        .font(.system(size: 12, weight: .medium))
                                        .foregroundStyle(announcement.authorRole.color)
                                    
                                    Text("•")
                                        .foregroundStyle(.secondary)
                                    
                                    Text(timeAgo)
                                        .font(.system(size: 12))
                                        .foregroundStyle(.secondary)
                                }
                            }
                            
                            Spacer()
                            
                            if announcement.isPinned {
                                Image(systemName: "pin.fill")
                                    .font(.system(size: 16))
                                    .foregroundStyle(.orange)
                            }
                        }
                        
                        Divider()
                            .background(colorScheme == .dark ? Color.white.opacity(0.1) : Color.gray.opacity(0.3))
                        
                        // Title
                        Text(announcement.title)
                            .font(.system(size: 26, weight: .bold))
                            .foregroundStyle(colorScheme == .dark ? .white : .primary)
                            .lineSpacing(4)
                        
                        // Content
                        Text(announcement.content)
                            .font(.system(size: 16))
                            .foregroundStyle(colorScheme == .dark ? .white.opacity(0.9) : .primary)
                            .lineSpacing(6)
                        
                        // Version Info (if updated)
                        if announcement.isUpdated {
                            HStack(spacing: 8) {
                                Image(systemName: "arrow.clockwise.circle.fill")
                                    .font(.system(size: 14))
                                    .foregroundStyle(.blue)
                                
                                Text("Updated • Version \(announcement.version)")
                                    .font(.system(size: 12, weight: .medium))
                                    .foregroundStyle(.blue)
                                
                                Spacer()
                                
                                Button(action: {}) {
                                    Text("View Changes")
                                        .font(.system(size: 12, weight: .semibold))
                                        .foregroundStyle(.blue)
                                }
                            }
                            .padding(12)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.blue.opacity(0.08))
                            )
                        }
                        
                        // Attachments
                        if !announcement.attachments.isEmpty {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Attachments")
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundStyle(colorScheme == .dark ? .white : .primary)
                                
                                ForEach(announcement.attachments) { attachment in
                                    AnnouncementAttachmentRow(attachment: attachment)
                                }
                            }
                        }
                        
                        // Engagement Stats
                        HStack(spacing: 24) {
                            HStack(spacing: 6) {
                                Image(systemName: "eye.fill")
                                    .font(.system(size: 14))
                                Text("\(announcement.viewCount)")
                                    .font(.system(size: 14, weight: .medium))
                            }
                            .foregroundStyle(.secondary)
                            
                            HStack(spacing: 6) {
                                Image(systemName: "checkmark.circle.fill")
                                    .font(.system(size: 14))
                                Text("\(announcement.acknowledgeCount)")
                                    .font(.system(size: 14, weight: .medium))
                            }
                            .foregroundStyle(.green)
                            
                            Spacer()
                        }
                        .padding(.top, 8)
                    }
                    .padding(24)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(.ultraThinMaterial)
                            .shadow(color: .black.opacity(0.1), radius: 20, x: 0, y: 10)
                    )
                    .padding(.horizontal, 20)
                    
                    // Acknowledge Button
                    Button(action: {}) {
                        HStack(spacing: 12) {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.system(size: 18))
                            
                            Text("Acknowledge")
                                .font(.system(size: 17, weight: .semibold))
                        }
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(
                                    LinearGradient(
                                        colors: [.green, .green.opacity(0.8)],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .shadow(color: .green.opacity(0.4), radius: 12, x: 0, y: 6)
                        )
                    }
                    .padding(.horizontal, 20)
                    
                    // Bottom spacing
                    Color.clear.frame(height: 40)
                }
            }
        }
        .navigationBarHidden(true)
    }
}

// MARK: - Announcement Attachment Row
struct AnnouncementAttachmentRow: View {
    let attachment: Attachment
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: attachment.type.icon)
                .font(.system(size: 20))
                .foregroundStyle(attachment.type.color)
                .frame(width: 44, height: 44)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(attachment.type.color.opacity(0.12))
                )
            
            VStack(alignment: .leading, spacing: 4) {
                Text(attachment.name)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(colorScheme == .dark ? .white : .primary)
                    .lineLimit(1)
                
                Text(attachment.sizeString)
                    .font(.system(size: 12))
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            Button(action: {}) {
                Image(systemName: "arrow.down.circle.fill")
                    .font(.system(size: 24))
                    .foregroundStyle(.blue)
            }
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(colorScheme == .dark ? Color.white.opacity(0.06) : Color.gray.opacity(0.08))
        )
    }
}

// MARK: - Preview
#Preview {
    NavigationStack {
        AnnouncementDetailView(
            announcement: Announcement(
                title: "Exam Venue Changed!",
                content: "Tomorrow's Database exam has been moved from Hall A to Hall B due to facility maintenance. Please arrive 15 minutes early to locate the new venue. The exam will start promptly at 9:00 AM. Don't forget to bring your student ID and necessary stationery. Good luck!",
                category: .exam,
                priority: .urgent,
                authorName: "Dr. Parker",
                authorRole: .lecturer,
                attachments: [
                    Attachment(name: "Venue Map.pdf", type: .pdf, size: 512000),
                    Attachment(name: "Exam Guidelines.pdf", type: .pdf, size: 1024000)
                ],
                isPinned: true
            )
        )
    }
}
