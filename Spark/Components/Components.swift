//
//  Components.swift
//  Spark
//
//  Created by STDC_34 on 18/12/2025.
//

import SwiftUI

// MARK: - Reusable UI Components
/// Collection of reusable components used throughout the app

// MARK: - Avatar View
/// A circular avatar with initials or image
struct AvatarView: View {
    let name: String
    let size: CGFloat
    let isLecturer: Bool
    var isOnline: Bool = false
    
    init(name: String, size: CGFloat = 44, isLecturer: Bool = false, isOnline: Bool = false) {
        self.name = name
        self.size = size
        self.isLecturer = isLecturer
        self.isOnline = isOnline
    }
    
    private var initials: String {
        let components = name.components(separatedBy: " ")
        return components.prefix(2).compactMap { $0.first }.map { String($0) }.joined().uppercased()
    }
    
    private var gradientColors: [Color] {
        isLecturer
            ? [Color.green.opacity(0.6), Color.teal.opacity(0.6)]
            : [Color.blue.opacity(0.6), Color.purple.opacity(0.6)]
    }
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            Circle()
                .fill(
                    LinearGradient(
                        colors: gradientColors,
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: size, height: size)
                .overlay(
                    Text(initials)
                        .font(.system(size: size * 0.4, weight: .semibold))
                        .foregroundStyle(.white)
                )
                .shadow(color: (isLecturer ? Color.green : Color.blue).opacity(0.3), radius: 8, x: 0, y: 4)
            
            if isOnline {
                Circle()
                    .fill(.green)
                    .frame(width: size * 0.28, height: size * 0.28)
                    .overlay(
                        Circle()
                            .stroke(.white, lineWidth: 2)
                    )
            }
        }
    }
}

// MARK: - Role Badge
/// A small badge showing user role (Student/Lecturer)
struct RoleBadge: View {
    let role: SparkUserRole
    
    var body: some View {
        Text(role.rawValue)
            .font(.system(size: 9, weight: .bold))
            .foregroundStyle(role.color)
            .padding(.horizontal, 6)
            .padding(.vertical, 2)
            .background(
                Capsule()
                    .fill(role.color.opacity(0.12))
            )
    }
}

// MARK: - Status Badge
/// A pill-shaped status indicator
struct StatusBadge: View {
    let text: String
    let color: Color
    var icon: String? = nil
    
    var body: some View {
        HStack(spacing: 4) {
            if let icon = icon {
                Image(systemName: icon)
                    .font(.system(size: 9))
            }
            Text(text)
                .font(.system(size: 11, weight: .semibold))
        }
        .foregroundStyle(color)
        .padding(.horizontal, 10)
        .padding(.vertical, 5)
        .background(
            Capsule()
                .fill(color.opacity(0.12))
        )
    }
}

// MARK: - Priority Indicator
/// A small circle indicating priority level
struct PriorityIndicator: View {
    let priority: AssignmentPriority
    var size: CGFloat = 8
    
    var body: some View {
        Circle()
            .fill(priority.color)
            .frame(width: size, height: size)
    }
}

// MARK: - Progress Bar
/// A horizontal progress bar with animation
struct SparkProgressBar: View {
    let progress: Double
    let color: Color
    var height: CGFloat = 6
    var showPercentage: Bool = false
    
    var body: some View {
        VStack(alignment: .trailing, spacing: 4) {
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: height / 2)
                        .fill(Color.gray.opacity(0.15))
                        .frame(height: height)
                    
                    RoundedRectangle(cornerRadius: height / 2)
                        .fill(color)
                        .frame(width: geo.size.width * min(max(progress, 0), 1), height: height)
                        .animation(.spring(response: 0.5), value: progress)
                }
            }
            .frame(height: height)
            
            if showPercentage {
                Text("\(Int(progress * 100))%")
                    .font(.system(size: 11, weight: .medium))
                    .foregroundStyle(color)
            }
        }
    }
}

// MARK: - Icon Badge
/// An icon with optional notification badge
struct IconBadge: View {
    let icon: String
    var badgeCount: Int = 0
    var iconColor: Color = .blue
    var badgeColor: Color = .red
    var size: CGFloat = 24
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            Image(systemName: icon)
                .font(.system(size: size, weight: .medium))
                .foregroundStyle(iconColor)
            
            if badgeCount > 0 {
                Text(badgeCount > 99 ? "99+" : "\(badgeCount)")
                    .font(.system(size: 10, weight: .bold))
                    .foregroundStyle(.white)
                    .frame(minWidth: 16, minHeight: 16)
                    .background(
                        Circle()
                            .fill(badgeColor)
                    )
                    .offset(x: 8, y: -8)
            }
        }
    }
}

// MARK: - Section Header
/// A reusable section header with optional action
struct SectionHeader: View {
    let title: String
    var actionTitle: String? = nil
    var action: (() -> Void)? = nil
    
    var body: some View {
        HStack {
            Text(title)
                .font(.system(size: 20, weight: .bold))
                .foregroundStyle(.primary)
            
            Spacer()
            
            if let actionTitle = actionTitle, let action = action {
                Button(actionTitle, action: action)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(.blue)
            }
        }
    }
}

// MARK: - Empty State View
/// A view shown when there's no content
struct EmptyStateView: View {
    let icon: String
    let title: String
    let message: String
    var actionTitle: String? = nil
    var action: (() -> Void)? = nil
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 56))
                .foregroundStyle(.gray.opacity(0.4))
            
            Text(title)
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(.primary)
            
            Text(message)
                .font(.system(size: 14))
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
            
            if let actionTitle = actionTitle, let action = action {
                Button(action: action) {
                    Text(actionTitle)
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.blue)
                                .shadow(color: Color.blue.opacity(0.3), radius: 8, x: 0, y: 4)
                        )
                }
            }
        }
        .padding(32)
    }
}

// MARK: - Loading View
/// A loading indicator with message
struct LoadingView: View {
    var message: String = "Loading..."
    
    var body: some View {
        VStack(spacing: 16) {
            ProgressView()
                .scaleEffect(1.2)
            
            Text(message)
                .font(.system(size: 14))
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// MARK: - Countdown Badge
/// Shows days remaining until deadline
struct CountdownBadge: View {
    let daysLeft: Int
    
    private var urgencyColor: Color {
        if daysLeft <= 1 { return .red }
        else if daysLeft <= 3 { return .orange }
        else { return .blue }
    }
    
    var body: some View {
        VStack(spacing: 2) {
            Text("\(daysLeft)")
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .foregroundStyle(urgencyColor)
            
            Text(daysLeft == 1 ? "day" : "days")
                .font(.system(size: 9, weight: .semibold))
                .foregroundStyle(urgencyColor.opacity(0.7))
        }
        .frame(width: 48, height: 48)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(urgencyColor.opacity(0.12))
        )
    }
}

// MARK: - Info Row
/// A simple row with icon, label and value
struct InfoRow: View {
    let icon: String
    let label: String
    let value: String
    var iconColor: Color = .secondary
    
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 12))
                .foregroundStyle(iconColor)
                .frame(width: 16)
            
            Text(label)
                .font(.system(size: 13))
                .foregroundStyle(.secondary)
            
            Spacer()
            
            Text(value)
                .font(.system(size: 13, weight: .medium))
                .foregroundStyle(.primary)
        }
    }
}

// MARK: - Floating Action Button
/// A floating action button typically used for primary actions
struct FloatingActionButton: View {
    let icon: String
    let color: Color
    let action: () -> Void
    
    @State private var isPressed = false
    
    var body: some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.system(size: 22, weight: .medium))
                .foregroundStyle(.white)
                .frame(width: 56, height: 56)
                .background(
                    Circle()
                        .fill(color)
                        .shadow(color: color.opacity(0.4), radius: 12, x: 0, y: 6)
                )
        }
        .scaleEffect(isPressed ? 0.9 : 1.0)
        .animation(.spring(response: 0.2), value: isPressed)
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in isPressed = true }
                .onEnded { _ in isPressed = false }
        )
    }
}

// MARK: - Chip View
/// A selectable chip/tag component
struct ChipView: View {
    let text: String
    let isSelected: Bool
    let action: () -> Void
    var color: Color = .blue
    
    var body: some View {
        Button(action: action) {
            Text(text)
                .font(.system(size: 13, weight: .medium))
                .foregroundStyle(isSelected ? .white : .primary)
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
                .background(
                    Capsule()
                        .fill(isSelected ? color : Color.gray.opacity(0.1))
                        .shadow(color: isSelected ? color.opacity(0.3) : .clear, radius: 8, x: 0, y: 4)
                )
        }
        .buttonStyle(.plain)
        .animation(.spring(response: 0.3), value: isSelected)
    }
}

// MARK: - Divider with Text
/// A divider with centered text
struct DividerWithText: View {
    let text: String
    
    var body: some View {
        HStack(spacing: 16) {
            Rectangle()
                .fill(Color.gray.opacity(0.2))
                .frame(height: 1)
            
            Text(text)
                .font(.system(size: 12))
                .foregroundStyle(.secondary)
            
            Rectangle()
                .fill(Color.gray.opacity(0.2))
                .frame(height: 1)
        }
    }
}

// MARK: - Previews
#Preview("Avatar Views") {
    HStack(spacing: 20) {
        AvatarView(name: "John Doe", size: 44, isLecturer: false, isOnline: true)
        AvatarView(name: "Prof Emmet", size: 44, isLecturer: true, isOnline: true)
        AvatarView(name: "Dr Parker", size: 44, isLecturer: true, isOnline: false)
    }
    .padding()
}

#Preview("Status Badges") {
    HStack(spacing: 12) {
        StatusBadge(text: "In Progress", color: .blue)
        StatusBadge(text: "Urgent", color: .red, icon: "exclamationmark.triangle.fill")
        StatusBadge(text: "New", color: .green)
    }
    .padding()
}

#Preview("Progress Bar") {
    VStack(spacing: 20) {
        SparkProgressBar(progress: 0.65, color: .blue, showPercentage: true)
        SparkProgressBar(progress: 0.3, color: .orange)
        SparkProgressBar(progress: 0.9, color: .green)
    }
    .padding()
}

#Preview("Empty State") {
    EmptyStateView(
        icon: "doc.text",
        title: "No Assignments",
        message: "You don't have any assignments yet. Check back later!",
        actionTitle: "Refresh"
    ) { }
}
