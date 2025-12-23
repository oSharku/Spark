//
//  AssignmentsView.swift
//  Spark
//
//  Assignments tracking view for the Spark student notification system
//

import SwiftUI

// MARK: - Assignments View
struct AssignmentsView: View {
    
    @StateObject private var appState = AppState.shared
    @State private var selectedFilter: AssignmentFilter = .all
    @State private var showCompleted: Bool = true
    @Environment(\.colorScheme) var colorScheme
    
    private var filteredAssignments: [Assignment] {
        var result = appState.assignments
        
        switch selectedFilter {
        case .all:
            break
        case .pending:
            result = result.filter { $0.status == .pending || $0.status == .inProgress }
        case .dueSoon:
            result = result.filter { $0.daysUntilDue >= 0 && $0.daysUntilDue <= 3 && $0.status != .submitted && $0.status != .graded }
        case .overdue:
            result = result.filter { $0.isOverdue }
        case .completed:
            result = result.filter { $0.status == .submitted || $0.status == .graded }
        }
        
        if !showCompleted && selectedFilter == .all {
            result = result.filter { $0.status != .submitted && $0.status != .graded }
        }
        
        return result.sorted { $0.dueDate < $1.dueDate }
    }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 20) {
                // Header
                AssignmentsHeader()
                
                // Stats Overview
                AssignmentStatsRow(assignments: appState.assignments)
                
                // Filter Pills
                AssignmentFilterBar(selectedFilter: $selectedFilter)
                
                // Toggle Completed
                if selectedFilter == .all {
                    Toggle(isOn: $showCompleted) {
                        Text("Show completed")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundStyle(.secondary)
                    }
                    .tint(.blue)
                    .padding(.horizontal, 4)
                }
                
                // Assignments List
                if filteredAssignments.isEmpty {
                    EmptyAssignmentsState(filter: selectedFilter)
                } else {
                    AssignmentsListSection(
                        assignments: filteredAssignments,
                        onStatusChange: { assignment, status in
                            appState.updateAssignmentStatus(assignment, status: status)
                        }
                    )
                }
                
                // Bottom spacing
                Color.clear.frame(height: 100)
            }
            .padding(.horizontal, 16)
        }
    }
}

// MARK: - Assignment Filter
enum AssignmentFilter: String, CaseIterable {
    case all = "All"
    case pending = "Pending"
    case dueSoon = "Due Soon"
    case overdue = "Overdue"
    case completed = "Completed"
    
    var icon: String {
        switch self {
        case .all: return "tray.full.fill"
        case .pending: return "clock.fill"
        case .dueSoon: return "exclamationmark.circle.fill"
        case .overdue: return "xmark.circle.fill"
        case .completed: return "checkmark.circle.fill"
        }
    }
    
    var color: Color {
        switch self {
        case .all: return .blue
        case .pending: return .orange
        case .dueSoon: return .yellow
        case .overdue: return .red
        case .completed: return .green
        }
    }
}

// MARK: - Assignments Header
struct AssignmentsHeader: View {
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Assignments")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundStyle(colorScheme == .dark ? .white : .primary)
                
                Text("Track your deadlines")
                    .font(.system(size: 14))
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            // Add assignment button
            Button(action: {}) {
                Image(systemName: "plus.circle.fill")
                    .font(.system(size: 28))
                    .foregroundStyle(.blue)
            }
        }
        .padding(.top, 8)
    }
}

// MARK: - Assignment Stats Row
struct AssignmentStatsRow: View {
    let assignments: [Assignment]
    @Environment(\.colorScheme) var colorScheme
    
    var pendingCount: Int { assignments.filter { $0.status == .pending || $0.status == .inProgress }.count }
    var dueSoonCount: Int { assignments.filter { $0.daysUntilDue >= 0 && $0.daysUntilDue <= 3 && $0.status != .submitted && $0.status != .graded }.count }
    var overdueCount: Int { assignments.filter { $0.isOverdue }.count }
    var completedCount: Int { assignments.filter { $0.status == .submitted || $0.status == .graded }.count }
    
    var body: some View {
        HStack(spacing: 10) {
            AssignmentStatPill(value: pendingCount, label: "Pending", color: .orange)
            AssignmentStatPill(value: dueSoonCount, label: "Due Soon", color: .red)
            AssignmentStatPill(value: completedCount, label: "Done", color: .green)
        }
    }
}

// MARK: - Assignment Stat Pill
struct AssignmentStatPill: View {
    let value: Int
    let label: String
    let color: Color
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(spacing: 4) {
            Text("\(value)")
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .foregroundStyle(color)
            
            Text(label)
                .font(.system(size: 11, weight: .medium))
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

// MARK: - Assignment Filter Bar
struct AssignmentFilterBar: View {
    @Binding var selectedFilter: AssignmentFilter
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(AssignmentFilter.allCases, id: \.self) { filter in
                    Button(action: {
                        withAnimation(.spring(response: 0.3)) {
                            selectedFilter = filter
                        }
                    }) {
                        HStack(spacing: 6) {
                            Image(systemName: filter.icon)
                                .font(.system(size: 11))
                            Text(filter.rawValue)
                                .font(.system(size: 13, weight: .medium))
                        }
                        .foregroundStyle(selectedFilter == filter ? .white : (colorScheme == .dark ? .white : .primary))
                        .padding(.horizontal, 14)
                        .padding(.vertical, 8)
                        .background(
                            Capsule()
                                .fill(selectedFilter == filter ? filter.color : (colorScheme == .dark ? Color.white.opacity(0.1) : Color.gray.opacity(0.1)))
                        )
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }
}

// MARK: - Empty State
struct EmptyAssignmentsState: View {
    let filter: AssignmentFilter
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: filter == .completed ? "checkmark.seal.fill" : "doc.text")
                .font(.system(size: 50))
                .foregroundStyle(.gray.opacity(0.4))
            
            Text(filter == .completed ? "No completed assignments" : "No assignments found")
                .font(.system(size: 17, weight: .semibold))
                .foregroundStyle(.secondary)
            
            Text(filter == .completed ? "Submitted assignments will appear here" : "You're all caught up!")
                .font(.system(size: 14))
                .foregroundStyle(.tertiary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 60)
    }
}

// MARK: - Assignments List Section
struct AssignmentsListSection: View {
    let assignments: [Assignment]
    let onStatusChange: (Assignment, AssignmentStatus) -> Void
    @Environment(\.colorScheme) var colorScheme
    
    // Group by due date category
    var groupedAssignments: [(String, [Assignment])] {
        let grouped = Dictionary(grouping: assignments) { $0.dueDateCategory.rawValue }
        let order: [String] = ["Overdue", "Today", "Due Soon", "This Week", "Next Week", "Later"]
        return order.compactMap { key in
            guard let items = grouped[key], !items.isEmpty else { return nil }
            return (key, items)
        }
    }
    
    var body: some View {
        VStack(spacing: 20) {
            ForEach(groupedAssignments, id: \.0) { category, items in
                VStack(alignment: .leading, spacing: 12) {
                    // Section Header
                    HStack {
                        Text(category)
                            .font(.system(size: 16, weight: .bold))
                            .foregroundStyle(DueDateCategory(rawValue: category)?.color ?? .gray)
                        
                        Spacer()
                        
                        Text("\(items.count)")
                            .font(.system(size: 13, weight: .medium))
                            .foregroundStyle(.secondary)
                    }
                    
                    // Assignment Cards
                    ForEach(items) { assignment in
                        AssignmentCard(assignment: assignment, onStatusChange: onStatusChange)
                    }
                }
            }
        }
    }
}

// MARK: - Assignment Card
struct AssignmentCard: View {
    let assignment: Assignment
    let onStatusChange: (Assignment, AssignmentStatus) -> Void
    @State private var isPressed = false
    @Environment(\.colorScheme) var colorScheme
    
    var dueDateText: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, h:mm a"
        return formatter.string(from: assignment.dueDate)
    }
    
    var daysText: String {
        let days = assignment.daysUntilDue
        if days < 0 {
            return "\(abs(days)) days overdue"
        } else if days == 0 {
            return "Due today"
        } else if days == 1 {
            return "Due tomorrow"
        } else {
            return "Due in \(days) days"
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Top Row
            HStack(alignment: .top) {
                // Priority Indicator
                Circle()
                    .fill(assignment.priority.color)
                    .frame(width: 10, height: 10)
                    .padding(.top, 4)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(assignment.title)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(colorScheme == .dark ? .white : .primary)
                        .lineLimit(2)
                    
                    HStack(spacing: 6) {
                        Text(assignment.courseCode)
                            .font(.system(size: 12, weight: .medium))
                            .foregroundStyle(.secondary)
                        
                        Text("•")
                            .foregroundStyle(.secondary)
                        
                        Text(assignment.lecturerName)
                            .font(.system(size: 12))
                            .foregroundStyle(.secondary)
                    }
                }
                
                Spacer()
                
                // Status Badge
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
            
            // Due Date Row
            HStack {
                HStack(spacing: 6) {
                    Image(systemName: "calendar")
                        .font(.system(size: 12))
                    Text(dueDateText)
                        .font(.system(size: 13))
                }
                .foregroundStyle(.secondary)
                
                Spacer()
                
                Text(daysText)
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(assignment.dueDateCategory.color)
            }
            
            // Grade (if graded)
            if let grade = assignment.grade {
                HStack {
                    Image(systemName: "star.fill")
                        .font(.system(size: 12))
                        .foregroundStyle(.yellow)
                    
                    Text("Grade: \(Int(grade))/\(Int(assignment.maxGrade))")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundStyle(.green)
                    
                    if let feedback = assignment.feedback, !feedback.isEmpty {
                        Text("• \(feedback)")
                            .font(.system(size: 12))
                            .foregroundStyle(.secondary)
                            .lineLimit(1)
                    }
                }
            }
            
            // Version indicator
            if assignment.version > 1 {
                HStack(spacing: 4) {
                    Image(systemName: "arrow.triangle.2.circlepath")
                        .font(.system(size: 10))
                    Text("Updated (v\(assignment.version))")
                        .font(.system(size: 11, weight: .medium))
                }
                .foregroundStyle(.blue)
            }
            
            // Action Buttons (for non-completed assignments)
            if assignment.status != .submitted && assignment.status != .graded {
                HStack(spacing: 10) {
                    if assignment.status == .pending {
                        ActionButton(title: "Start", icon: "play.fill", color: .blue) {
                            onStatusChange(assignment, .inProgress)
                        }
                    }
                    
                    if assignment.status == .inProgress {
                        ActionButton(title: "Submit", icon: "arrow.up.circle.fill", color: .green) {
                            onStatusChange(assignment, .submitted)
                        }
                    }
                    
                    ActionButton(title: "Details", icon: "info.circle", color: .gray, isOutlined: true) {
                        // Show details
                    }
                }
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(colorScheme == .dark ? Color.white.opacity(0.06) : Color.white.opacity(0.7))
                .shadow(color: .black.opacity(colorScheme == .dark ? 0.2 : 0.05), radius: 10, x: 0, y: 4)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 18)
                .stroke(assignment.isOverdue ? Color.red.opacity(0.3) : Color.clear, lineWidth: 1)
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
    }
}

// MARK: - Action Button
struct ActionButton: View {
    let title: String
    let icon: String
    let color: Color
    var isOutlined: Bool = false
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.system(size: 12))
                Text(title)
                    .font(.system(size: 13, weight: .medium))
            }
            .foregroundStyle(isOutlined ? color : .white)
            .padding(.horizontal, 14)
            .padding(.vertical, 8)
            .background(
                Group {
                    if isOutlined {
                        Capsule()
                            .stroke(color, lineWidth: 1)
                    } else {
                        Capsule()
                            .fill(color)
                    }
                }
            )
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Preview
#Preview {
    ZStack {
        LinearGradient(
            colors: [Color.blue.opacity(0.3), Color.cyan.opacity(0.4)],
            startPoint: .top,
            endPoint: .bottom
        )
        .ignoresSafeArea()
        
        AssignmentsView()
    }
}
