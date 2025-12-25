//
//  NotificationsManagerView.swift
//  Spark
//
//  Notifications Manager view for managing alert preferences
//

import SwiftUI

// MARK: - Notifications Manager View
struct NotificationsManagerView: View {
    
    // MARK: - Properties
    @Binding var isPresented: Bool
    @Environment(\.colorScheme) var colorScheme
    @AppStorage("assignmentAlerts") private var assignmentAlerts = true
    @AppStorage("examReminders") private var examReminders = true
    @AppStorage("clubUpdates") private var clubUpdates = false
    @AppStorage("dailySparkBriefing") private var dailySparkBriefing = true
    
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
                        // Header Card
                        notificationHeaderCard
                        
                        // Notifications Section
                        notificationsSection
                        
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
                Image(systemName: "chevron.left")
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundStyle(.white)
            }
            
            // Title
            Text("Notifications")
                .font(.system(size: 32, weight: .bold))
                .foregroundStyle(.white)
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
    }
    
    // MARK: - Notification Header Card
    private var notificationHeaderCard: some View {
        HStack(spacing: 16) {
            Image(systemName: "bell.badge.fill")
                .font(.system(size: 40))
                .foregroundStyle(.white)
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Stay Updated")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(.white)
                
                Text("Customize what alerts you receive")
                    .font(.system(size: 14))
                    .foregroundStyle(.white.opacity(0.8))
            }
            
            Spacer()
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(
                    LinearGradient(
                        colors: [Color.red.opacity(0.8), Color.orange.opacity(0.8)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
        )
    }
    
    // MARK: - Notifications Section
    private var notificationsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("ALERT PREFERENCES")
                .font(.system(size: 12, weight: .semibold))
                .foregroundStyle(.white.opacity(0.7))
                .padding(.leading, 4)
            
            VStack(spacing: 0) {
                // Assignment Alerts
                NotificationToggleRow(
                    icon: "doc.text.fill",
                    iconColor: .blue,
                    title: "Assignment Alerts",
                    subtitle: "Get notified about new assignments and deadlines",
                    isOn: $assignmentAlerts
                )
                
                Divider()
                    .background(Color.white.opacity(0.1))
                
                // Exam Reminders
                NotificationToggleRow(
                    icon: "calendar.badge.exclamationmark",
                    iconColor: .red,
                    title: "Exam Reminders",
                    subtitle: "Receive reminders before upcoming exams",
                    isOn: $examReminders
                )
                
                Divider()
                    .background(Color.white.opacity(0.1))
                
                // Club Updates
                NotificationToggleRow(
                    icon: "person.3.fill",
                    iconColor: .purple,
                    title: "Club Updates",
                    subtitle: "Stay informed about club activities and events",
                    isOn: $clubUpdates
                )
                
                Divider()
                    .background(Color.white.opacity(0.1))
                
                // Daily Spark Briefing
                NotificationToggleRow(
                    icon: "sparkles",
                    iconColor: .orange,
                    title: "Daily Spark Briefing",
                    subtitle: "Get your personalized daily summary",
                    isOn: $dailySparkBriefing
                )
            }
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(colorScheme == .dark ? Color.white.opacity(0.08) : Color.white.opacity(0.2))
            )
        }
    }
}

// MARK: - Notification Toggle Row
struct NotificationToggleRow: View {
    let icon: String
    let iconColor: Color
    let title: String
    let subtitle: String
    @Binding var isOn: Bool
    
    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: icon)
                .font(.system(size: 18))
                .foregroundStyle(iconColor)
                .frame(width: 36, height: 36)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(iconColor.opacity(0.15))
                )
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 15, weight: .medium))
                    .foregroundStyle(.white)
                
                Text(subtitle)
                    .font(.system(size: 12))
                    .foregroundStyle(.white.opacity(0.6))
            }
            
            Spacer()
            
            Toggle("", isOn: $isOn)
                .labelsHidden()
                .tint(.blue)
        }
        .padding(14)
    }
}

// MARK: - Preview
#Preview {
    NotificationsManagerView(isPresented: .constant(true))
}
