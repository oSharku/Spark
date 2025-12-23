//
//  UpdatesView.swift
//  Spark
//
//  Updates/Notifications view for the Spark student notification system
//

import SwiftUI

// MARK: - Updates View
struct UpdatesView: View {
    
    // MARK: - Properties
    @Binding var showSideMenu: Bool
    @Binding var showRewardsPage: Bool
    @State private var selectedFilter: NotifFilterType = .all
    @State private var sortOrder: NotifSortOrder = .newest
    @State private var searchText: String = ""
    @State private var notifications: [NotifItem] = NotifItem.sampleData
    @Environment(\.colorScheme) var colorScheme
    
    // MARK: - Filtered Notifications
    private var filteredNotifications: [NotifItem] {
        var result = notifications
        
        // Search filter
        if !searchText.isEmpty {
            result = result.filter {
                $0.title.localizedCaseInsensitiveContains(searchText) ||
                $0.message.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        // Category filter
        if selectedFilter != .all {
            result = result.filter { $0.category == selectedFilter }
        }
        
        // Sort
        switch sortOrder {
        case .newest:
            result.sort { $0.timestamp > $1.timestamp }
        case .oldest:
            result.sort { $0.timestamp < $1.timestamp }
        case .urgentFirst:
            result.sort { $0.priority.sortValue < $1.priority.sortValue }
        }
        
        return result
    }
    
    var unreadCount: Int {
        notifications.filter { !$0.isRead }.count
    }
    
    // MARK: - Body
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 16) {
                // Header
                UpdatesPageHeader(showSideMenu: $showSideMenu, unreadCount: unreadCount)
                
                // Compact Points Bar with Redeem button
                CompactPointsBar(showRewardsPage: $showRewardsPage)
                
                // Search Bar
                NotifSearchBar(searchText: $searchText)
                
                // Quick Stats - synced with actual unread count
                NotifQuickStats(
                    total: notifications.count,
                    unread: unreadCount,
                    urgent: notifications.filter { $0.priority == .urgent }.count
                )
                
                // Filters & Sort
                NotifFiltersBar(
                    selectedFilter: $selectedFilter,
                    sortOrder: $sortOrder,
                    onMarkAllRead: markAllAsRead
                )
                
                // Notifications List
                NotifListSection(
                    notifications: filteredNotifications,
                    onToggleRead: toggleRead,
                    onDelete: deleteNotification
                )
                
                // Bottom spacing
                Color.clear.frame(height: 100)
            }
            .padding(.horizontal, 16)
        }
    }
    
    // MARK: - Actions
    private func markAllAsRead() {
        withAnimation(.spring(response: 0.3)) {
            for i in notifications.indices {
                notifications[i].isRead = true
            }
        }
    }
    
    private func toggleRead(_ notification: NotifItem) {
        if let index = notifications.firstIndex(where: { $0.id == notification.id }) {
            withAnimation(.spring(response: 0.3)) {
                notifications[index].isRead.toggle()
            }
        }
    }
    
    private func deleteNotification(_ notification: NotifItem) {
        withAnimation(.spring(response: 0.3)) {
            notifications.removeAll { $0.id == notification.id }
        }
    }
}

// MARK: - Notification Item Model
struct NotifItem: Identifiable {
    let id = UUID()
    let title: String
    let message: String
    let source: String
    let category: NotifFilterType
    let priority: NotifPriority
    let timestamp: Date
    var isRead: Bool
    let icon: String
    
    static var sampleData: [NotifItem] {
        [
            NotifItem(
                title: "Exam Venue Changed!",
                message: "Tomorrow's Database exam moved from Hall A to Hall B. Please arrive 15 minutes early.",
                source: "Dr. Parker",
                category: .exams,
                priority: .urgent,
                timestamp: Date().addingTimeInterval(-1800),
                isRead: false,
                icon: "exclamationmark.triangle.fill"
            ),
            NotifItem(
                title: "New Assignment Posted",
                message: "AR App Final Project has been posted. Due date: December 22, 2025.",
                source: "Prof. Emmet • HCI",
                category: .assignments,
                priority: .high,
                timestamp: Date().addingTimeInterval(-3600),
                isRead: false,
                icon: "doc.badge.plus"
            ),
            NotifItem(
                title: "Quiz Tomorrow",
                message: "Reminder: Database Systems quiz on Chapter 5 & 6 tomorrow at 9 AM.",
                source: "Dr. Smith",
                category: .exams,
                priority: .high,
                timestamp: Date().addingTimeInterval(-7200),
                isRead: false,
                icon: "pencil.and.ruler.fill"
            ),
            NotifItem(
                title: "Club Fair This Friday!",
                message: "Tech Club booth at Student Hall. Free pizza and coding challenges!",
                source: "Tech Club",
                category: .clubs,
                priority: .normal,
                timestamp: Date().addingTimeInterval(-14400),
                isRead: true,
                icon: "person.3.fill"
            ),
            NotifItem(
                title: "New Notes Uploaded",
                message: "Chapter 5: Advanced JavaScript Functions notes are now available.",
                source: "Dr. Parker • Web Dev",
                category: .files,
                priority: .normal,
                timestamp: Date().addingTimeInterval(-28800),
                isRead: true,
                icon: "folder.badge.plus"
            ),
            NotifItem(
                title: "Assignment Graded",
                message: "Your Database ER Diagram has been graded. Score: 92/100. Great work!",
                source: "Dr. Smith",
                category: .assignments,
                priority: .normal,
                timestamp: Date().addingTimeInterval(-43200),
                isRead: true,
                icon: "star.fill"
            ),
            NotifItem(
                title: "Lab Session Rescheduled",
                message: "Friday's Mobile Dev lab moved to Monday 3 PM due to equipment maintenance.",
                source: "Dr. Lee",
                category: .announcements,
                priority: .high,
                timestamp: Date().addingTimeInterval(-50400),
                isRead: false,
                icon: "calendar.badge.exclamationmark"
            ),
            NotifItem(
                title: "Project Team Meeting",
                message: "HCI project team meeting at Library Room 3 tomorrow at 5 PM.",
                source: "Sarah (Team Lead)",
                category: .announcements,
                priority: .normal,
                timestamp: Date().addingTimeInterval(-64800),
                isRead: true,
                icon: "person.2.fill"
            )
        ]
    }
}

// MARK: - Filter Type
enum NotifFilterType: String, CaseIterable {
    case all = "All"
    case assignments = "Assignments"
    case exams = "Exams"
    case files = "Files"
    case clubs = "Clubs"
    case announcements = "Announcements"
    
    var icon: String {
        switch self {
        case .all: return "tray.full.fill"
        case .assignments: return "doc.text.fill"
        case .exams: return "pencil.and.ruler.fill"
        case .files: return "folder.fill"
        case .clubs: return "person.3.fill"
        case .announcements: return "megaphone.fill"
        }
    }
}

// MARK: - Sort Order
enum NotifSortOrder: String, CaseIterable {
    case newest = "Newest"
    case oldest = "Oldest"
    case urgentFirst = "Urgent First"
}

// MARK: - Priority
enum NotifPriority {
    case urgent, high, normal, low
    
    var color: Color {
        switch self {
        case .urgent: return .red
        case .high: return .orange
        case .normal: return .blue
        case .low: return .gray
        }
    }
    
    var label: String {
        switch self {
        case .urgent: return "Urgent"
        case .high: return "Important"
        case .normal: return "New"
        case .low: return "Info"
        }
    }
    
    var sortValue: Int {
        switch self {
        case .urgent: return 0
        case .high: return 1
        case .normal: return 2
        case .low: return 3
        }
    }
}

// MARK: - Updates Page Header
struct UpdatesPageHeader: View {
    @Binding var showSideMenu: Bool
    let unreadCount: Int
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Updates")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundStyle(colorScheme == .dark ? .white : .primary)
                
                if unreadCount > 0 {
                    Text("\(unreadCount) unread notifications")
                        .font(.system(size: 14))
                        .foregroundStyle(.secondary)
                } else {
                    Text("You're all caught up!")
                        .font(.system(size: 14))
                        .foregroundStyle(.green)
                }
            }
            
            Spacer()
            
            // Menu Button
            Button(action: {
                withAnimation(.spring(response: 0.35)) {
                    showSideMenu = true
                }
            }) {
                Image(systemName: "line.3.horizontal")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundStyle(colorScheme == .dark ? .white : .primary)
                    .frame(width: 44, height: 44)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(.ultraThinMaterial)
                            .shadow(color: .black.opacity(0.08), radius: 8, x: 0, y: 4)
                    )
            }
        }
        .padding(.top, 8)
    }
}

// MARK: - Compact Points Bar
struct CompactPointsBar: View {
    @Binding var showRewardsPage: Bool
    @StateObject private var appState = AppState.shared
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        HStack(spacing: 14) {
            // Points Icon
            Circle()
                .fill(LinearGradient(colors: [.yellow, .orange], startPoint: .topLeading, endPoint: .bottomTrailing))
                .frame(width: 40, height: 40)
                .overlay(
                    Image(systemName: "star.fill")
                        .font(.system(size: 18))
                        .foregroundStyle(.white)
                )
                .shadow(color: .orange.opacity(0.3), radius: 6, x: 0, y: 3)
            
            // Points Info - Tap to reset to 500 (for testing)
            VStack(alignment: .leading, spacing: 2) {
                HStack(spacing: 6) {
                    Text("\(appState.currentUser.points)")
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                        .foregroundStyle(colorScheme == .dark ? .white : .primary)
                        .onTapGesture {
                            withAnimation(.spring(response: 0.3)) {
                                appState.resetPoints()
                            }
                        }
                    
                    Text("points")
                        .font(.system(size: 14))
                        .foregroundStyle(.secondary)
                }
                
                Text("Tap number to reset • Redeem →")
                    .font(.system(size: 11))
                    .foregroundStyle(.blue)
            }
            
            Spacer()
            
            // Redeem Button - opens rewards page
            Button(action: {
                withAnimation(.easeInOut(duration: 0.3)) {
                    showRewardsPage = true
                }
            }) {
                Text("Redeem")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(
                        Capsule()
                            .fill(LinearGradient(colors: [.blue, .blue.opacity(0.8)], startPoint: .leading, endPoint: .trailing))
                            .shadow(color: .blue.opacity(0.3), radius: 6, x: 0, y: 3)
                    )
            }
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.ultraThinMaterial)
                .shadow(color: .black.opacity(0.06), radius: 10, x: 0, y: 4)
        )
    }
}

// MARK: - Search Bar
struct NotifSearchBar: View {
    @Binding var searchText: String
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 16))
                .foregroundStyle(.secondary)
            
            TextField("Search notifications...", text: $searchText)
                .font(.system(size: 15))
            
            if !searchText.isEmpty {
                Button(action: { searchText = "" }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 18))
                        .foregroundStyle(.secondary)
                }
            }
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(colorScheme == .dark ? Color.white.opacity(0.08) : Color.gray.opacity(0.1))
        )
    }
}

// MARK: - Quick Stats
struct NotifQuickStats: View {
    let total: Int
    let unread: Int
    let urgent: Int
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        HStack(spacing: 12) {
            QuickStatPill(value: "\(total)", label: "Total", color: .blue)
            QuickStatPill(value: "\(unread)", label: "Unread", color: .orange)
            QuickStatPill(value: "\(urgent)", label: "Urgent", color: .red)
        }
    }
}

struct QuickStatPill: View {
    let value: String
    let label: String
    let color: Color
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        HStack(spacing: 8) {
            Text(value)
                .font(.system(size: 18, weight: .bold, design: .rounded))
                .foregroundStyle(color)
            
            Text(label)
                .font(.system(size: 12, weight: .medium))
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(color.opacity(colorScheme == .dark ? 0.15 : 0.1))
        )
    }
}

// MARK: - Filters Bar
struct NotifFiltersBar: View {
    @Binding var selectedFilter: NotifFilterType
    @Binding var sortOrder: NotifSortOrder
    let onMarkAllRead: () -> Void
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(spacing: 12) {
            // Filter Pills
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(NotifFilterType.allCases, id: \.self) { filter in
                        NotifFilterPill(
                            filter: filter,
                            isSelected: selectedFilter == filter
                        ) {
                            withAnimation(.spring(response: 0.3)) {
                                selectedFilter = filter
                            }
                        }
                    }
                }
            }
            
            // Sort & Actions Row
            HStack {
                // Sort Menu
                Menu {
                    ForEach(NotifSortOrder.allCases, id: \.self) { order in
                        Button(action: { sortOrder = order }) {
                            HStack {
                                Text(order.rawValue)
                                if sortOrder == order {
                                    Image(systemName: "checkmark")
                                }
                            }
                        }
                    }
                } label: {
                    HStack(spacing: 4) {
                        Image(systemName: "arrow.up.arrow.down")
                            .font(.system(size: 12))
                        Text(sortOrder.rawValue)
                            .font(.system(size: 13, weight: .medium))
                        Image(systemName: "chevron.down")
                            .font(.system(size: 10))
                    }
                    .foregroundStyle(colorScheme == .dark ? .white : .primary)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(colorScheme == .dark ? Color.white.opacity(0.1) : Color.gray.opacity(0.1))
                    )
                }
                
                Spacer()
                
                // Mark All Read
                Button(action: onMarkAllRead) {
                    HStack(spacing: 4) {
                        Image(systemName: "checkmark.circle")
                            .font(.system(size: 12))
                        Text("Mark all read")
                            .font(.system(size: 13, weight: .medium))
                    }
                    .foregroundStyle(.blue)
                }
            }
        }
    }
}

// MARK: - Filter Pill
struct NotifFilterPill: View {
    let filter: NotifFilterType
    let isSelected: Bool
    let action: () -> Void
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Image(systemName: filter.icon)
                    .font(.system(size: 11))
                Text(filter.rawValue)
                    .font(.system(size: 13, weight: .medium))
            }
            .foregroundStyle(isSelected ? .white : (colorScheme == .dark ? .white : .primary))
            .padding(.horizontal, 14)
            .padding(.vertical, 8)
            .background(
                Capsule()
                    .fill(isSelected ? Color.blue : (colorScheme == .dark ? Color.white.opacity(0.1) : Color.gray.opacity(0.1)))
            )
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Notifications List Section
struct NotifListSection: View {
    let notifications: [NotifItem]
    let onToggleRead: (NotifItem) -> Void
    let onDelete: (NotifItem) -> Void
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(spacing: 10) {
            if notifications.isEmpty {
                // Empty State
                VStack(spacing: 16) {
                    Image(systemName: "bell.slash")
                        .font(.system(size: 50))
                        .foregroundStyle(.gray.opacity(0.4))
                    
                    Text("No notifications")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundStyle(.secondary)
                    
                    Text("You're all caught up!")
                        .font(.system(size: 14))
                        .foregroundStyle(.tertiary)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 60)
            } else {
                ForEach(notifications) { notification in
                    NotifCard(
                        notification: notification,
                        onToggleRead: { onToggleRead(notification) },
                        onDelete: { onDelete(notification) }
                    )
                }
            }
        }
    }
}

// MARK: - Notification Card
struct NotifCard: View {
    let notification: NotifItem
    let onToggleRead: () -> Void
    let onDelete: () -> Void
    
    @State private var isPressed = false
    @Environment(\.colorScheme) var colorScheme
    
    private var timeAgo: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: notification.timestamp, relativeTo: Date())
    }
    
    private var cardBackground: Color {
        if notification.isRead {
            return colorScheme == .dark ? Color.white.opacity(0.04) : Color.white.opacity(0.6)
        } else {
            return colorScheme == .dark ? Color.white.opacity(0.08) : Color.white.opacity(0.9)
        }
    }
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            // Icon
            ZStack {
                Circle()
                    .fill(notification.priority.color.opacity(0.15))
                    .frame(width: 44, height: 44)
                
                Image(systemName: notification.icon)
                    .font(.system(size: 18))
                    .foregroundStyle(notification.priority.color)
            }
            
            // Content
            VStack(alignment: .leading, spacing: 6) {
                // Title Row
                HStack(alignment: .top) {
                    // Unread dot
                    if !notification.isRead {
                        Circle()
                            .fill(.blue)
                            .frame(width: 8, height: 8)
                            .padding(.top, 5)
                    }
                    
                    Text(notification.title)
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(colorScheme == .dark ? .white : .primary)
                        .lineLimit(2)
                    
                    Spacer()
                    
                    // Priority Badge
                    Text(notification.priority.label)
                        .font(.system(size: 10, weight: .bold))
                        .foregroundStyle(notification.priority.color)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(
                            Capsule()
                                .fill(notification.priority.color.opacity(0.12))
                        )
                }
                
                // Message
                Text(notification.message)
                    .font(.system(size: 13))
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
                
                // Footer
                HStack {
                    Text(notification.source)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundStyle(colorScheme == .dark ? .white.opacity(0.6) : .primary.opacity(0.6))
                    
                    Spacer()
                    
                    Text(timeAgo)
                        .font(.system(size: 11))
                        .foregroundStyle(.secondary)
                }
            }
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(cardBackground)
                .shadow(color: .black.opacity(colorScheme == .dark ? 0.2 : 0.05), radius: 8, x: 0, y: 4)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(notification.isRead ? Color.clear : notification.priority.color.opacity(0.2), lineWidth: 1)
        )
        .scaleEffect(isPressed ? 0.98 : 1.0)
        .onTapGesture {
            withAnimation(.spring(response: 0.2)) {
                isPressed = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.spring(response: 0.2)) {
                    isPressed = false
                }
            }
        }
        .contextMenu {
            Button(action: onToggleRead) {
                Label(notification.isRead ? "Mark as Unread" : "Mark as Read",
                      systemImage: notification.isRead ? "envelope.badge" : "envelope.open")
            }
            
            Button(role: .destructive, action: onDelete) {
                Label("Delete", systemImage: "trash")
            }
        }
    }
}

// MARK: - Preview
#Preview {
    ZStack {
        LinearGradient(
            colors: [Color.blue.opacity(0.3), Color.blue.opacity(0.5)],
            startPoint: .top,
            endPoint: .bottom
        )
        .ignoresSafeArea()
        
        UpdatesView(showSideMenu: .constant(false), showRewardsPage: .constant(false))
    }
}
