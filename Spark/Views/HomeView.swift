//
//  HomeView.swift
//  Spark
//
//  Home dashboard view for the Spark student notification system
//

import SwiftUI

// MARK: - Home View
struct HomeView: View {
    
    // MARK: - Properties
    @Binding var showSideMenu: Bool
    @StateObject private var appState = AppState.shared
    @State private var currentSliderIndex: Int = 0
    @State private var selectedDay: Int? = nil
    @State private var showEventPopup: Bool = false
    @State private var selectedDayEvents: [CalendarEventModel] = []
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 20) {
                // Header
                HomeHeaderView(
                    showSideMenu: $showSideMenu,
                    userName: appState.currentUser.name.components(separatedBy: " ").first ?? "User",
                    streak: appState.currentUser.currentStreak
                )
                
                // Today Stats Overview
                TodayStatsView(stats: appState.todayStats)
                
                // Urgent Announcements Slider
                UrgentAnnouncementsSlider(
                    announcements: appState.announcements.filter { $0.priority == .urgent || $0.priority == .high }.prefix(5).map { $0 },
                    currentIndex: $currentSliderIndex
                )
                
                // Weekly Glance
                WeeklyGlanceSection(
                    events: appState.calendarEvents,
                    selectedDay: $selectedDay,
                    showEventPopup: $showEventPopup,
                    selectedDayEvents: $selectedDayEvents
                )
                
                // Open Assignments
                HomeAssignmentsSection(assignments: appState.assignments.filter { $0.status != .submitted && $0.status != .graded }.prefix(4).map { $0 })
                
                // Upcoming Events
                UpcomingEventsSection(events: appState.calendarEvents.filter { $0.date > Date() }.prefix(3).map { $0 })
                
                // Quick Actions
                QuickActionsSection()
                
                // Bottom spacing
                Color.clear.frame(height: 100)
            }
            .padding(.horizontal, 16)
        }
        .overlay {
            if showEventPopup {
                EventPopupView(
                    events: selectedDayEvents,
                    isPresented: $showEventPopup
                )
            }
        }
    }
}

// MARK: - Home Header View
struct HomeHeaderView: View {
    @Binding var showSideMenu: Bool
    let userName: String
    let streak: Int
    @Environment(\.colorScheme) var colorScheme
    
    private var greetingText: String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 5..<12: return "Good morning"
        case 12..<17: return "Good afternoon"
        case 17..<21: return "Good evening"
        default: return "Good night"
        }
    }
    
    var body: some View {
        HStack(spacing: 12) {
            // Profile Section
            HStack(spacing: 10) {
                // Avatar
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [Color.blue.opacity(0.6), Color.purple.opacity(0.6)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 44, height: 44)
                    .overlay(
                        Text(String(userName.prefix(1)).uppercased())
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundStyle(.white)
                    )
                    .shadow(color: .blue.opacity(0.3), radius: 8, x: 0, y: 4)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("Hi, \(userName)")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundStyle(colorScheme == .dark ? .white : .primary)
                    
                    Text(greetingText)
                        .font(.system(size: 12))
                        .foregroundStyle(.secondary)
                }
                
                // Streak Badge
                if streak > 0 {
                    HStack(spacing: 4) {
                        Image(systemName: "flame.fill")
                            .font(.system(size: 14))
                            .foregroundStyle(.orange)
                        Text("\(streak)")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundStyle(.orange)
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(
                        Capsule()
                            .fill(Color.orange.opacity(0.15))
                    )
                }
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: 22)
                    .fill(.ultraThinMaterial)
                    .shadow(color: .black.opacity(0.08), radius: 10, x: 0, y: 4)
            )
            
            Spacer()
            
            // Menu Button
            Button(action: {
                withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                    showSideMenu = true
                }
            }) {
                Image(systemName: "line.3.horizontal")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundStyle(colorScheme == .dark ? .white : .primary)
                    .frame(width: 44, height: 44)
                    .background(
                        RoundedRectangle(cornerRadius: 14)
                            .fill(.ultraThinMaterial)
                            .shadow(color: .black.opacity(0.08), radius: 8, x: 0, y: 4)
                    )
            }
        }
        .padding(.top, 8)
    }
}

// MARK: - Today Stats View
struct TodayStatsView: View {
    let stats: TodayStats
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        HStack(spacing: 10) {
            TodayStatItem(value: "\(stats.unreadAnnouncements)", label: "Unread", icon: "bell.badge.fill", color: .red)
            TodayStatItem(value: "\(stats.pendingAssignments)", label: "Pending", icon: "doc.text.fill", color: .orange)
            TodayStatItem(value: "\(stats.todayEvents)", label: "Today", icon: "calendar", color: .blue)
            TodayStatItem(value: "\(stats.points)", label: "Points", icon: "star.fill", color: .yellow)
        }
    }
}

// MARK: - Today Stat Item
struct TodayStatItem: View {
    let value: String
    let label: String
    let icon: String
    let color: Color
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(spacing: 6) {
            Image(systemName: icon)
                .font(.system(size: 16))
                .foregroundStyle(color)
            
            Text(value)
                .font(.system(size: 18, weight: .bold, design: .rounded))
                .foregroundStyle(colorScheme == .dark ? .white : .primary)
            
            Text(label)
                .font(.system(size: 10, weight: .medium))
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(color.opacity(colorScheme == .dark ? 0.15 : 0.1))
        )
    }
}

// MARK: - Urgent Announcements Slider
struct UrgentAnnouncementsSlider: View {
    let announcements: [Announcement]
    @Binding var currentIndex: Int
    
    var body: some View {
        if !announcements.isEmpty {
            VStack(spacing: 12) {
                TabView(selection: $currentIndex) {
                    ForEach(Array(announcements.enumerated()), id: \.element.id) { index, announcement in
                        AnnouncementSliderCard(announcement: announcement)
                            .tag(index)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .frame(height: 150)
                
                // Page Indicators
                HStack(spacing: 8) {
                    ForEach(0..<announcements.count, id: \.self) { index in
                        Capsule()
                            .fill(index == currentIndex ? announcements[index].priority.color : Color.gray.opacity(0.3))
                            .frame(width: index == currentIndex ? 24 : 8, height: 8)
                            .animation(.spring(response: 0.3), value: currentIndex)
                    }
                }
            }
        }
    }
}

// MARK: - Announcement Slider Card
struct AnnouncementSliderCard: View {
    let announcement: Announcement
    @State private var isPressed = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            // Label Badge
            HStack(spacing: 6) {
                Image(systemName: announcement.category.icon)
                    .font(.system(size: 11))
                Text(announcement.priority.rawValue.uppercased())
                    .font(.system(size: 11, weight: .bold))
            }
            .foregroundStyle(.white.opacity(0.9))
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(
                Capsule()
                    .fill(.white.opacity(0.25))
            )
            
            Text(announcement.title)
                .font(.system(size: 18, weight: .bold))
                .foregroundStyle(.white)
                .lineLimit(2)
            
            Text(announcement.content)
                .font(.system(size: 13))
                .foregroundStyle(.white.opacity(0.85))
                .lineLimit(2)
            
            Spacer()
            
            HStack {
                Text(announcement.authorName)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(.white.opacity(0.7))
                
                Spacer()
                
                Text(announcement.createdAt.timeAgoShort)
                    .font(.system(size: 11))
                    .foregroundStyle(.white.opacity(0.6))
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(
                    LinearGradient(
                        colors: [announcement.priority.color, announcement.priority.color.opacity(0.7)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .shadow(color: announcement.priority.color.opacity(0.4), radius: 12, x: 0, y: 6)
        )
        .scaleEffect(isPressed ? 0.97 : 1.0)
        .onTapGesture {
            withAnimation(.spring(response: 0.2)) { isPressed = true }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.spring(response: 0.2)) { isPressed = false }
            }
        }
    }
}

// MARK: - Weekly Glance Section
struct WeeklyGlanceSection: View {
    let events: [CalendarEventModel]
    @Binding var selectedDay: Int?
    @Binding var showEventPopup: Bool
    @Binding var selectedDayEvents: [CalendarEventModel]
    @Environment(\.colorScheme) var colorScheme
    
    private var currentWeekDates: [Date] {
        let calendar = Calendar.current
        let today = Date()
        let weekday = calendar.component(.weekday, from: today)
        let daysToSubtract = weekday - 1
        guard let startOfWeek = calendar.date(byAdding: .day, value: -daysToSubtract, to: today) else { return [] }
        return (0..<7).compactMap { calendar.date(byAdding: .day, value: $0, to: startOfWeek) }
    }
    
    private func getEventsForDate(_ date: Date) -> [CalendarEventModel] {
        events.filter { Calendar.current.isDate($0.date, inSameDayAs: date) }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Weekly Glance")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundStyle(colorScheme == .dark ? .white : .primary)
                    
                    Text(weekRangeText)
                        .font(.system(size: 12))
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
                
                Button(action: {}) {
                    Image(systemName: "calendar")
                        .font(.system(size: 16))
                        .foregroundStyle(.blue)
                        .frame(width: 32, height: 32)
                        .background(Circle().fill(Color.blue.opacity(0.1)))
                }
            }
            
            HStack(spacing: 6) {
                ForEach(Array(currentWeekDates.enumerated()), id: \.offset) { _, date in
                    let calendar = Calendar.current
                    let day = calendar.component(.day, from: date)
                    let isToday = calendar.isDateInToday(date)
                    let dayEvents = getEventsForDate(date)
                    let hasEvents = !dayEvents.isEmpty
                    
                    WeekDayButton(
                        date: date,
                        isToday: isToday,
                        hasEvents: hasEvents,
                        eventColors: dayEvents.prefix(3).map { $0.color }
                    ) {
                        if hasEvents {
                            selectedDay = day
                            selectedDayEvents = dayEvents
                            showEventPopup = true
                        }
                    }
                }
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.ultraThinMaterial)
                .shadow(color: .black.opacity(0.06), radius: 10, x: 0, y: 4)
        )
    }
    
    private var weekRangeText: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        guard let first = currentWeekDates.first, let last = currentWeekDates.last else { return "" }
        return "\(formatter.string(from: first)) - \(formatter.string(from: last))"
    }
}

// MARK: - Week Day Button
struct WeekDayButton: View {
    let date: Date
    let isToday: Bool
    let hasEvents: Bool
    let eventColors: [Color]
    let action: () -> Void
    @Environment(\.colorScheme) var colorScheme
    
    private var dayName: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE"
        return formatter.string(from: date).prefix(1).uppercased() + formatter.string(from: date).dropFirst().prefix(1).lowercased()
    }
    
    private var dayNumber: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter.string(from: date)
    }
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Text(dayName)
                    .font(.system(size: 10, weight: .medium))
                    .foregroundStyle(isToday ? .white : .secondary)
                
                Text(dayNumber)
                    .font(.system(size: 15, weight: .bold))
                    .foregroundStyle(isToday ? .white : (colorScheme == .dark ? .white : .primary))
                
                HStack(spacing: 2) {
                    ForEach(Array(eventColors.enumerated()), id: \.offset) { _, color in
                        Circle()
                            .fill(isToday ? .white : color)
                            .frame(width: 5, height: 5)
                    }
                }
                .frame(height: 6)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isToday ? Color.blue : (hasEvents ? (colorScheme == .dark ? Color.white.opacity(0.08) : Color.gray.opacity(0.08)) : Color.clear))
            )
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Event Popup View
struct EventPopupView: View {
    let events: [CalendarEventModel]
    @Binding var isPresented: Bool
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                .ignoresSafeArea()
                .onTapGesture {
                    withAnimation(.spring(response: 0.3)) { isPresented = false }
                }
            
            VStack(spacing: 16) {
                HStack {
                    Text("Events")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundStyle(colorScheme == .dark ? .white : .primary)
                    
                    Spacer()
                    
                    Button(action: {
                        withAnimation(.spring(response: 0.3)) { isPresented = false }
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 24))
                            .foregroundStyle(.gray.opacity(0.5))
                    }
                }
                
                ForEach(events) { event in
                    EventPopupRow(event: event)
                }
            }
            .padding(24)
            .background(
                RoundedRectangle(cornerRadius: 24)
                    .fill(.ultraThickMaterial)
                    .shadow(color: .black.opacity(0.2), radius: 30, x: 0, y: 15)
            )
            .padding(.horizontal, 32)
            .transition(.scale.combined(with: .opacity))
        }
    }
}

// MARK: - Event Popup Row
struct EventPopupRow: View {
    let event: CalendarEventModel
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        HStack(spacing: 12) {
            Circle()
                .fill(event.color.opacity(0.15))
                .frame(width: 40, height: 40)
                .overlay(
                    Image(systemName: event.type.icon)
                        .font(.system(size: 16))
                        .foregroundStyle(event.color)
                )
            
            VStack(alignment: .leading, spacing: 4) {
                Text(event.title)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(colorScheme == .dark ? .white : .primary)
                
                HStack(spacing: 6) {
                    Text(event.location)
                        .font(.system(size: 11))
                        .foregroundStyle(.secondary)
                    
                    Text("•")
                        .foregroundStyle(.secondary)
                    
                    Text(event.startTime.formatted(date: .omitted, time: .shortened))
                        .font(.system(size: 11, weight: .medium))
                        .foregroundStyle(event.color)
                }
            }
            
            Spacer()
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(colorScheme == .dark ? Color.white.opacity(0.06) : Color.gray.opacity(0.08))
        )
    }
}

// MARK: - Home Assignments Section
struct HomeAssignmentsSection: View {
    let assignments: [Assignment]
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Text("Open Assignments")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(colorScheme == .dark ? .white : .primary)
                
                Spacer()
                
                Button("View all") {}
                    .font(.system(size: 13, weight: .medium))
                    .foregroundStyle(.blue)
            }
            
            if assignments.isEmpty {
                Text("No pending assignments")
                    .font(.system(size: 14))
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 20)
            } else {
                VStack(spacing: 10) {
                    ForEach(assignments) { assignment in
                        HomeAssignmentRow(assignment: assignment)
                    }
                }
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.ultraThinMaterial)
                .shadow(color: .black.opacity(0.06), radius: 10, x: 0, y: 4)
        )
    }
}

// MARK: - Home Assignment Row
struct HomeAssignmentRow: View {
    let assignment: Assignment
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        HStack(spacing: 12) {
            Circle()
                .fill(assignment.priority.color)
                .frame(width: 8, height: 8)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(assignment.title)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(colorScheme == .dark ? .white : .primary)
                    .lineLimit(1)
                
                HStack(spacing: 6) {
                    Text(assignment.courseCode)
                        .font(.system(size: 11))
                        .foregroundStyle(.secondary)
                    
                    Text("•")
                        .foregroundStyle(.secondary)
                    
                    Text(assignment.dueDate.formatted(date: .abbreviated, time: .shortened))
                        .font(.system(size: 11, weight: .medium))
                        .foregroundStyle(assignment.dueDateCategory.color)
                }
            }
            
            Spacer()
            
            Text(assignment.status.rawValue)
                .font(.system(size: 10, weight: .bold))
                .foregroundStyle(assignment.status.color)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(
                    Capsule()
                        .fill(assignment.status.color.opacity(0.12))
                )
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(colorScheme == .dark ? Color.white.opacity(0.06) : Color.white.opacity(0.6))
        )
    }
}

// MARK: - Upcoming Events Section
struct UpcomingEventsSection: View {
    let events: [CalendarEventModel]
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Text("Upcoming")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(colorScheme == .dark ? .white : .primary)
                
                Spacer()
                
                Button("See all") {}
                    .font(.system(size: 13, weight: .medium))
                    .foregroundStyle(.blue)
            }
            
            ForEach(events) { event in
                UpcomingEventRow(event: event)
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.ultraThinMaterial)
                .shadow(color: .black.opacity(0.06), radius: 10, x: 0, y: 4)
        )
    }
}

// MARK: - Upcoming Event Row
struct UpcomingEventRow: View {
    let event: CalendarEventModel
    @Environment(\.colorScheme) var colorScheme
    
    private var daysUntil: Int {
        Calendar.current.dateComponents([.day], from: Date(), to: event.date).day ?? 0
    }
    
    var body: some View {
        HStack(spacing: 12) {
            VStack(spacing: 2) {
                Text("\(max(daysUntil, 0))")
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                    .foregroundStyle(event.color)
                
                Text(daysUntil == 1 ? "day" : "days")
                    .font(.system(size: 9, weight: .medium))
                    .foregroundStyle(.secondary)
            }
            .frame(width: 44, height: 44)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(event.color.opacity(0.12))
            )
            
            VStack(alignment: .leading, spacing: 4) {
                Text(event.title)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(colorScheme == .dark ? .white : .primary)
                    .lineLimit(1)
                
                HStack(spacing: 6) {
                    Text(event.type.rawValue)
                        .font(.system(size: 11))
                        .foregroundStyle(.secondary)
                    
                    Text("•")
                        .foregroundStyle(.secondary)
                    
                    Text(event.location)
                        .font(.system(size: 11))
                        .foregroundStyle(.secondary)
                }
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.system(size: 12))
                .foregroundStyle(.gray.opacity(0.5))
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(colorScheme == .dark ? Color.white.opacity(0.06) : Color.white.opacity(0.6))
        )
    }
}

// MARK: - Quick Actions Section
struct QuickActionsSection: View {
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Quick Actions")
                .font(.system(size: 18, weight: .bold))
                .foregroundStyle(colorScheme == .dark ? .white : .primary)
            
            HStack(spacing: 12) {
                QuickActionItem(icon: "doc.badge.plus", title: "Submit", color: .blue)
                QuickActionItem(icon: "calendar.badge.plus", title: "Schedule", color: .purple)
                QuickActionItem(icon: "bell.badge", title: "Remind", color: .orange)
                QuickActionItem(icon: "qrcode.viewfinder", title: "Scan", color: .green)
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.ultraThinMaterial)
                .shadow(color: .black.opacity(0.06), radius: 10, x: 0, y: 4)
        )
    }
}

// MARK: - Quick Action Item
struct QuickActionItem: View {
    let icon: String
    let title: String
    let color: Color
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        Button(action: {}) {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundStyle(color)
                    .frame(width: 44, height: 44)
                    .background(
                        RoundedRectangle(cornerRadius: 14)
                            .fill(color.opacity(0.12))
                    )
                
                Text(title)
                    .font(.system(size: 11, weight: .medium))
                    .foregroundStyle(colorScheme == .dark ? .white : .primary)
            }
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Date Extension
extension Date {
    var timeAgoShort: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: self, relativeTo: Date())
    }
}

// MARK: - Preview
#Preview {
    ZStack {
        Color.blue.opacity(0.2).ignoresSafeArea()
        HomeView(showSideMenu: .constant(false))
    }
}
