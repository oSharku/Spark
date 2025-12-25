//
//  NotificationDetailView.swift
//  Spark
//
//  Detailed notification view showing full content and actions
//

import SwiftUI

// MARK: - Notification Detail View
struct NotificationDetailView: View {
    
    let notification: NotifItem
    let onMarkAsRead: (() -> Void)?
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme
    @State private var isMarkedAsRead = false
    @State private var showToast = false
    @State private var toastMessage = ""
    
    init(notification: NotifItem, onMarkAsRead: (() -> Void)? = nil) {
        self.notification = notification
        self.onMarkAsRead = onMarkAsRead
        _isMarkedAsRead = State(initialValue: notification.isRead)
    }
    
    private var timeAgo: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        return formatter.localizedString(for: notification.timestamp, relativeTo: Date())
    }
    
    var body: some View {
        ZStack {
            // Background
            SparkBackground()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 24) {
                    // Header with back button
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
                                Label("Archive", systemImage: "archivebox")
                            }
                            Button(role: .destructive, action: {}) {
                                Label("Delete", systemImage: "trash")
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
                    
                    // Icon & Priority Badge
                    VStack(spacing: 16) {
                        ZStack {
                            Circle()
                                .fill(notification.priority.color.opacity(0.15))
                                .frame(width: 80, height: 80)
                            
                            Image(systemName: notification.icon)
                                .font(.system(size: 36))
                                .foregroundStyle(notification.priority.color)
                        }
                        .shadow(color: notification.priority.color.opacity(0.3), radius: 12, x: 0, y: 6)
                        
                        Text(notification.priority.label)
                            .font(.system(size: 13, weight: .bold))
                            .foregroundStyle(notification.priority.color)
                            .padding(.horizontal, 14)
                            .padding(.vertical, 6)
                            .background(
                                Capsule()
                                    .fill(notification.priority.color.opacity(0.12))
                            )
                    }
                    
                    // Content Card
                    VStack(alignment: .leading, spacing: 20) {
                        // Category Badge
                        HStack {
                            Image(systemName: notification.category.icon)
                                .font(.system(size: 12))
                            Text(notification.category.rawValue)
                                .font(.system(size: 13, weight: .medium))
                        }
                        .foregroundStyle(.blue)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(
                            Capsule()
                                .fill(Color.blue.opacity(0.1))
                        )
                        
                        // Title
                        Text(notification.title)
                            .font(.system(size: 24, weight: .bold))
                            .foregroundStyle(colorScheme == .dark ? .white : .primary)
                        
                        // Metadata
                        HStack(spacing: 16) {
                            Label {
                                Text(notification.source)
                                    .font(.system(size: 14, weight: .medium))
                            } icon: {
                                Image(systemName: "person.circle.fill")
                                    .font(.system(size: 16))
                            }
                            .foregroundStyle(.secondary)
                            
                            Label {
                                Text(timeAgo)
                                    .font(.system(size: 14))
                            } icon: {
                                Image(systemName: "clock.fill")
                                    .font(.system(size: 14))
                            }
                            .foregroundStyle(.secondary)
                        }
                        
                        Divider()
                            .background(colorScheme == .dark ? Color.white.opacity(0.1) : Color.gray.opacity(0.3))
                        
                        // Message
                        Text(notification.message)
                            .font(.system(size: 16))
                            .foregroundStyle(colorScheme == .dark ? .white.opacity(0.9) : .primary)
                            .lineSpacing(6)
                        
                        // Action Buttons based on category
                        if notification.category == .assignments {
                            HStack(spacing: 12) {
                                Button(action: {}) {
                                    Label("View Assignment", systemImage: "doc.text")
                                        .font(.system(size: 15, weight: .semibold))
                                        .foregroundStyle(.white)
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 14)
                                        .background(
                                            RoundedRectangle(cornerRadius: 12)
                                                .fill(LinearGradient(colors: [.blue, .blue.opacity(0.8)], startPoint: .leading, endPoint: .trailing))
                                        )
                                }
                                
                                Button(action: {}) {
                                    Image(systemName: "calendar.badge.plus")
                                        .font(.system(size: 18))
                                        .foregroundStyle(.blue)
                                        .frame(width: 50, height: 50)
                                        .background(
                                            RoundedRectangle(cornerRadius: 12)
                                                .fill(Color.blue.opacity(0.1))
                                        )
                                }
                            }
                            .padding(.top, 8)
                        } else if notification.category == .exams {
                            Button(action: {}) {
                                Label("View Exam Details", systemImage: "pencil.and.ruler")
                                    .font(.system(size: 15, weight: .semibold))
                                    .foregroundStyle(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 14)
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(LinearGradient(colors: [.orange, .orange.opacity(0.8)], startPoint: .leading, endPoint: .trailing))
                                    )
                            }
                            .padding(.top, 8)
                        } else if notification.category == .files {
                            Button(action: {}) {
                                Label("Open File", systemImage: "folder.fill")
                                    .font(.system(size: 15, weight: .semibold))
                                    .foregroundStyle(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 14)
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(LinearGradient(colors: [.green, .green.opacity(0.8)], startPoint: .leading, endPoint: .trailing))
                                    )
                            }
                            .padding(.top, 8)
                        }
                    }
                    .padding(24)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(.ultraThinMaterial)
                            .shadow(color: .black.opacity(0.1), radius: 20, x: 0, y: 10)
                    )
                    .padding(.horizontal, 20)
                    
                    // Action Buttons
                    VStack(spacing: 12) {
                        // Mark as Read Button
                        Button(action: {
                            if !isMarkedAsRead {
                                withAnimation(.spring(response: 0.3)) {
                                    isMarkedAsRead = true
                                }
                                onMarkAsRead?()
                                
                                // Show toast and dismiss after delay
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                    dismiss()
                                }
                            }
                        }) {
                            HStack(spacing: 12) {
                                Image(systemName: isMarkedAsRead ? "checkmark.circle.fill" : "envelope.open.fill")
                                    .font(.system(size: 18))
                                
                                Text(isMarkedAsRead ? "Marked as Read" : "Mark as Read")
                                    .font(.system(size: 17, weight: .semibold))
                            }
                            .foregroundStyle(isMarkedAsRead ? .green : .white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(
                                        isMarkedAsRead 
                                        ? LinearGradient(colors: [.green.opacity(0.2), .green.opacity(0.1)], startPoint: .leading, endPoint: .trailing)
                                        : LinearGradient(colors: [.blue, .blue.opacity(0.8)], startPoint: .leading, endPoint: .trailing)
                                    )
                                    .shadow(color: isMarkedAsRead ? .clear : .blue.opacity(0.4), radius: 12, x: 0, y: 6)
                            )
                        }
                        .disabled(isMarkedAsRead)
                        
                        // Remind Me Button
                        Button(action: {
                            withAnimation(.spring(response: 0.3)) {
                                toastMessage = "Reminder Set for 10 minutes"
                                showToast = true
                            }
                            
                            // Hide toast after 2 seconds and dismiss
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                                withAnimation(.spring(response: 0.3)) {
                                    showToast = false
                                }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                    dismiss()
                                }
                            }
                        }) {
                            HStack(spacing: 12) {
                                Image(systemName: "bell.badge")
                                    .font(.system(size: 18))
                                
                                Text("Remind Me in 10 Mins")
                                    .font(.system(size: 17, weight: .semibold))
                            }
                            .foregroundStyle(.blue)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color.blue.opacity(0.12))
                            )
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    // Related Notifications (optional future feature)
                    if notification.category != .all {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Related")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundStyle(colorScheme == .dark ? .white : .primary)
                                .padding(.horizontal, 20)
                            
                            Text("No related notifications")
                                .font(.system(size: 14))
                                .foregroundStyle(.secondary)
                                .padding(.horizontal, 20)
                        }
                    }
                    
                    // Bottom spacing
                    Color.clear.frame(height: 60)
                }
            }
            
            // Toast Notification
            if showToast {
                VStack {
                    Spacer()
                    
                    HStack(spacing: 12) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 20))
                            .foregroundStyle(.green)
                        
                        Text(toastMessage)
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundStyle(colorScheme == .dark ? .white : .primary)
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 16)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(.ultraThickMaterial)
                            .shadow(color: .black.opacity(0.2), radius: 20, x: 0, y: 10)
                    )
                    .padding(.horizontal, 40)
                    .padding(.bottom, 40)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }
        }
        .navigationBarHidden(true)
    }
}

// MARK: - Preview
#Preview {
    NavigationStack {
        NotificationDetailView(
            notification: NotifItem(
                title: "Exam Venue Changed!",
                message: "Tomorrow's Database exam moved from Hall A to Hall B. Please arrive 15 minutes early.",
                source: "Dr. Parker",
                category: .exams,
                priority: .urgent,
                timestamp: Date().addingTimeInterval(-1800),
                isRead: false,
                icon: "exclamationmark.triangle.fill"
            )
        )
    }
}
