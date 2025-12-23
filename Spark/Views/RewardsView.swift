//
//  RewardsView.swift
//  Spark
//
//  Rewards and achievements view for the Spark student notification system
//

import SwiftUI

// MARK: - Rewards View
struct RewardsView: View {
    
    // MARK: - Properties
    @Binding var isPresented: Bool
    @StateObject private var appState = AppState.shared
    @State private var selectedTab: RewardsTab = .overview
    @State private var showRedeemSheet: Bool = false
    @State private var selectedReward: Reward?
    @Environment(\.colorScheme) var colorScheme
    
    // MARK: - Body
    var body: some View {
        ZStack {
            // Background
            backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Navigation Header with Back Button
                navigationHeader
                
                // Scrollable Content
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 20) {
                        // Points & Streak Card
                        PointsStreakCard(
                            points: appState.currentUser.points,
                            currentStreak: appState.currentUser.currentStreak,
                            longestStreak: appState.currentUser.longestStreak
                        )
                        
                        // Tab Selector
                        RewardsTabSelector(selectedTab: $selectedTab)
                        
                        // Content based on tab
                        switch selectedTab {
                        case .overview:
                            OverviewSection(appState: appState)
                        case .badges:
                            BadgesSection(badges: appState.currentUser.badges)
                        case .rewards:
                            RewardsShopSection(
                                rewards: appState.availableRewards,
                                userPoints: appState.currentUser.points,
                                onSelectReward: { reward in
                                    selectedReward = reward
                                    showRedeemSheet = true
                                }
                            )
                        case .history:
                            HistorySection()
                        }
                        
                        // Bottom spacing
                        Color.clear.frame(height: 40)
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 8)
                }
            }
        }
        .sheet(isPresented: $showRedeemSheet) {
            if let reward = selectedReward {
                RedeemSheet(reward: reward, userPoints: appState.currentUser.points) {
                    if appState.redeemReward(reward) {
                        showRedeemSheet = false
                    }
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
                        Color(hex: "E8F4FD"),
                        Color(hex: "B8D4E8"),
                        Color(hex: "7EB8DA")
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
                HStack(spacing: 6) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 18, weight: .semibold))
                    Text("Back")
                        .font(.system(size: 17, weight: .medium))
                }
                .foregroundStyle(.blue)
            }
            
            Spacer()
            
            // Title
            Text("Rewards")
                .font(.system(size: 18, weight: .bold))
                .foregroundStyle(colorScheme == .dark ? .white : .primary)
            
            Spacer()
            
            // Reset Points Button (for testing)
            Button(action: {
                withAnimation(.spring(response: 0.3)) {
                    appState.resetPoints()
                }
            }) {
                Image(systemName: "arrow.counterclockwise.circle.fill")
                    .font(.system(size: 22))
                    .foregroundStyle(.blue)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .background(
            Rectangle()
                .fill(.ultraThinMaterial)
                .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
        )
    }
}

// MARK: - Rewards Tab
enum RewardsTab: String, CaseIterable {
    case overview = "Overview"
    case badges = "Badges"
    case rewards = "Shop"
    case history = "History"
    
    var icon: String {
        switch self {
        case .overview: return "chart.bar.fill"
        case .badges: return "medal.fill"
        case .rewards: return "gift.fill"
        case .history: return "clock.fill"
        }
    }
}

// MARK: - Rewards Header
struct RewardsHeader: View {
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Rewards")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundStyle(colorScheme == .dark ? .white : .primary)
                
                Text("Earn points, unlock badges!")
                    .font(.system(size: 14))
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            // Info button
            Button(action: {}) {
                Image(systemName: "info.circle")
                    .font(.system(size: 22))
                    .foregroundStyle(.blue)
            }
        }
        .padding(.top, 8)
    }
}

// MARK: - Points & Streak Card
struct PointsStreakCard: View {
    let points: Int
    let currentStreak: Int
    let longestStreak: Int
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(spacing: 16) {
            // Main Stats
            HStack(spacing: 20) {
                // Points
                VStack(spacing: 8) {
                    ZStack {
                        Circle()
                            .fill(LinearGradient(colors: [.yellow, .orange], startPoint: .topLeading, endPoint: .bottomTrailing))
                            .frame(width: 60, height: 60)
                            .shadow(color: .orange.opacity(0.4), radius: 10, x: 0, y: 5)
                        
                        Image(systemName: "star.fill")
                            .font(.system(size: 28))
                            .foregroundStyle(.white)
                    }
                    
                    Text("\(points)")
                        .font(.system(size: 32, weight: .bold, design: .rounded))
                        .foregroundStyle(colorScheme == .dark ? .white : .primary)
                    
                    Text("Points")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity)
                
                // Divider
                Rectangle()
                    .fill(colorScheme == .dark ? Color.white.opacity(0.2) : Color.gray.opacity(0.2))
                    .frame(width: 1, height: 80)
                
                // Streak
                VStack(spacing: 8) {
                    ZStack {
                        Circle()
                            .fill(LinearGradient(colors: [.red, .orange], startPoint: .topLeading, endPoint: .bottomTrailing))
                            .frame(width: 60, height: 60)
                            .shadow(color: .red.opacity(0.4), radius: 10, x: 0, y: 5)
                        
                        Image(systemName: "flame.fill")
                            .font(.system(size: 28))
                            .foregroundStyle(.white)
                    }
                    
                    Text("\(currentStreak)")
                        .font(.system(size: 32, weight: .bold, design: .rounded))
                        .foregroundStyle(colorScheme == .dark ? .white : .primary)
                    
                    Text("Day Streak")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity)
            }
            
            // Streak Progress
            VStack(spacing: 8) {
                HStack {
                    Text("Next milestone: 14 days")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundStyle(.secondary)
                    
                    Spacer()
                    
                    Text("\(currentStreak)/14")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundStyle(.orange)
                }
                
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(colorScheme == .dark ? Color.white.opacity(0.15) : Color.gray.opacity(0.2))
                            .frame(height: 8)
                        
                        RoundedRectangle(cornerRadius: 4)
                            .fill(LinearGradient(colors: [.red, .orange], startPoint: .leading, endPoint: .trailing))
                            .frame(width: geo.size.width * CGFloat(min(currentStreak, 14)) / 14, height: 8)
                    }
                }
                .frame(height: 8)
            }
            
            // Longest Streak
            HStack {
                Image(systemName: "trophy.fill")
                    .font(.system(size: 14))
                    .foregroundStyle(.yellow)
                
                Text("Longest streak: \(longestStreak) days")
                    .font(.system(size: 13))
                    .foregroundStyle(.secondary)
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.ultraThinMaterial)
                .shadow(color: .black.opacity(0.08), radius: 15, x: 0, y: 8)
        )
    }
}

// MARK: - Tab Selector
struct RewardsTabSelector: View {
    @Binding var selectedTab: RewardsTab
    @Namespace private var animation
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        HStack(spacing: 8) {
            ForEach(RewardsTab.allCases, id: \.self) { tab in
                Button(action: {
                    withAnimation(.spring(response: 0.3)) {
                        selectedTab = tab
                    }
                }) {
                    HStack(spacing: 6) {
                        Image(systemName: tab.icon)
                            .font(.system(size: 12))
                        Text(tab.rawValue)
                            .font(.system(size: 13, weight: .medium))
                    }
                    .foregroundStyle(selectedTab == tab ? .white : (colorScheme == .dark ? .white : .primary))
                    .padding(.horizontal, 14)
                    .padding(.vertical, 10)
                    .background {
                        if selectedTab == tab {
                            Capsule()
                                .fill(Color.blue)
                                .matchedGeometryEffect(id: "rewardTab", in: animation)
                        } else {
                            Capsule()
                                .fill(colorScheme == .dark ? Color.white.opacity(0.1) : Color.gray.opacity(0.1))
                        }
                    }
                }
                .buttonStyle(.plain)
            }
        }
    }
}

// MARK: - Overview Section
struct OverviewSection: View {
    @ObservedObject var appState: AppState
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(spacing: 16) {
            // How to Earn Points
            VStack(alignment: .leading, spacing: 14) {
                Text("How to Earn Points")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(colorScheme == .dark ? .white : .primary)
                
                VStack(spacing: 10) {
                    EarnPointsRow(icon: "eye.fill", title: "View Announcements", points: "+5", color: .blue)
                    EarnPointsRow(icon: "checkmark.circle.fill", title: "Acknowledge Updates", points: "+10", color: .green)
                    EarnPointsRow(icon: "doc.badge.arrow.up.fill", title: "Submit On Time", points: "+20", color: .purple)
                    EarnPointsRow(icon: "flame.fill", title: "7-Day Streak", points: "+50", color: .orange)
                    EarnPointsRow(icon: "calendar.badge.checkmark", title: "RSVP to Events", points: "+15", color: .cyan)
                }
            }
            .padding(18)
            .background(
                RoundedRectangle(cornerRadius: 18)
                    .fill(.ultraThinMaterial)
                    .shadow(color: .black.opacity(0.06), radius: 10, x: 0, y: 4)
            )
            
            // Recent Badges
            if !appState.currentUser.badges.filter({ $0.isEarned }).isEmpty {
                VStack(alignment: .leading, spacing: 14) {
                    HStack {
                        Text("Recent Badges")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundStyle(colorScheme == .dark ? .white : .primary)
                        
                        Spacer()
                        
                        Button("See all") {}
                            .font(.system(size: 14, weight: .medium))
                            .foregroundStyle(.blue)
                    }
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 14) {
                            ForEach(appState.currentUser.badges.filter { $0.isEarned }) { badge in
                                BadgeMiniCard(badge: badge)
                            }
                        }
                    }
                }
                .padding(18)
                .background(
                    RoundedRectangle(cornerRadius: 18)
                        .fill(.ultraThinMaterial)
                        .shadow(color: .black.opacity(0.06), radius: 10, x: 0, y: 4)
                )
            }
            
            // Weekly Progress
            WeeklyProgressCard()
        }
    }
}

// MARK: - Earn Points Row
struct EarnPointsRow: View {
    let icon: String
    let title: String
    let points: String
    let color: Color
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        HStack(spacing: 12) {
            Circle()
                .fill(color.opacity(0.15))
                .frame(width: 38, height: 38)
                .overlay(
                    Image(systemName: icon)
                        .font(.system(size: 16))
                        .foregroundStyle(color)
                )
            
            Text(title)
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(colorScheme == .dark ? .white : .primary)
            
            Spacer()
            
            Text(points)
                .font(.system(size: 14, weight: .bold))
                .foregroundStyle(.green)
        }
    }
}

// MARK: - Badge Mini Card
struct BadgeMiniCard: View {
    let badge: Badge
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(spacing: 10) {
            Circle()
                .fill(badge.color.opacity(0.15))
                .frame(width: 56, height: 56)
                .overlay(
                    Image(systemName: badge.icon)
                        .font(.system(size: 24))
                        .foregroundStyle(badge.color)
                )
            
            Text(badge.name)
                .font(.system(size: 12, weight: .medium))
                .foregroundStyle(colorScheme == .dark ? .white : .primary)
                .multilineTextAlignment(.center)
                .lineLimit(2)
        }
        .frame(width: 80)
    }
}

// MARK: - Weekly Progress Card
struct WeeklyProgressCard: View {
    @Environment(\.colorScheme) var colorScheme
    
    let weekDays = ["M", "T", "W", "T", "F", "S", "S"]
    let completedDays = [true, true, true, true, false, false, false] // Example data
    
    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("This Week's Progress")
                .font(.system(size: 18, weight: .bold))
                .foregroundStyle(colorScheme == .dark ? .white : .primary)
            
            HStack(spacing: 12) {
                ForEach(0..<7, id: \.self) { index in
                    VStack(spacing: 8) {
                        Circle()
                            .fill(completedDays[index] ? Color.green : (colorScheme == .dark ? Color.white.opacity(0.15) : Color.gray.opacity(0.2)))
                            .frame(width: 36, height: 36)
                            .overlay(
                                Image(systemName: completedDays[index] ? "checkmark" : "")
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundStyle(.white)
                            )
                        
                        Text(weekDays[index])
                            .font(.system(size: 12, weight: .medium))
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .frame(maxWidth: .infinity)
            
            HStack {
                Image(systemName: "info.circle")
                    .font(.system(size: 12))
                Text("Check in daily to maintain your streak!")
                    .font(.system(size: 12))
            }
            .foregroundStyle(.secondary)
        }
        .padding(18)
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(.ultraThinMaterial)
                .shadow(color: .black.opacity(0.06), radius: 10, x: 0, y: 4)
        )
    }
}

// MARK: - Badges Section
struct BadgesSection: View {
    let badges: [Badge]
    @Environment(\.colorScheme) var colorScheme
    
    var earnedBadges: [Badge] { badges.filter { $0.isEarned } }
    var lockedBadges: [Badge] { badges.filter { !$0.isEarned } }
    
    var body: some View {
        VStack(spacing: 20) {
            // Earned Badges
            if !earnedBadges.isEmpty {
                VStack(alignment: .leading, spacing: 14) {
                    HStack {
                        Text("Earned (\(earnedBadges.count))")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundStyle(colorScheme == .dark ? .white : .primary)
                        
                        Spacer()
                    }
                    
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 14) {
                        ForEach(earnedBadges) { badge in
                            BadgeCard(badge: badge, isEarned: true)
                        }
                    }
                }
            }
            
            // Locked Badges
            if !lockedBadges.isEmpty {
                VStack(alignment: .leading, spacing: 14) {
                    HStack {
                        Text("Locked (\(lockedBadges.count))")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundStyle(colorScheme == .dark ? .white : .primary)
                        
                        Spacer()
                    }
                    
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 14) {
                        ForEach(lockedBadges) { badge in
                            BadgeCard(badge: badge, isEarned: false)
                        }
                    }
                }
            }
        }
    }
}

// MARK: - Badge Card
struct BadgeCard: View {
    let badge: Badge
    let isEarned: Bool
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(isEarned ? badge.color.opacity(0.15) : (colorScheme == .dark ? Color.white.opacity(0.08) : Color.gray.opacity(0.1)))
                    .frame(width: 64, height: 64)
                
                Image(systemName: badge.icon)
                    .font(.system(size: 28))
                    .foregroundStyle(isEarned ? badge.color : .gray)
                
                if !isEarned {
                    Image(systemName: "lock.fill")
                        .font(.system(size: 14))
                        .foregroundStyle(.gray)
                        .offset(x: 22, y: 22)
                }
            }
            
            VStack(spacing: 4) {
                Text(badge.name)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(isEarned ? (colorScheme == .dark ? .white : .primary) : .gray)
                
                Text(badge.requirement)
                    .font(.system(size: 11))
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(colorScheme == .dark ? Color.white.opacity(0.06) : Color.white.opacity(0.6))
                .shadow(color: .black.opacity(colorScheme == .dark ? 0.2 : 0.04), radius: 8, x: 0, y: 4)
        )
        .opacity(isEarned ? 1.0 : 0.7)
    }
}

// MARK: - Rewards Shop Section
struct RewardsShopSection: View {
    let rewards: [Reward]
    let userPoints: Int
    let onSelectReward: (Reward) -> Void
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(spacing: 14) {
            ForEach(rewards) { reward in
                RewardShopCard(reward: reward, userPoints: userPoints) {
                    onSelectReward(reward)
                }
            }
        }
    }
}

// MARK: - Reward Shop Card
struct RewardShopCard: View {
    let reward: Reward
    let userPoints: Int
    let onRedeem: () -> Void
    @Environment(\.colorScheme) var colorScheme
    
    var canAfford: Bool { userPoints >= reward.pointsCost }
    
    var body: some View {
        HStack(spacing: 14) {
            // Icon
            RoundedRectangle(cornerRadius: 14)
                .fill(reward.color.opacity(0.15))
                .frame(width: 60, height: 60)
                .overlay(
                    Image(systemName: reward.icon)
                        .font(.system(size: 26))
                        .foregroundStyle(reward.color)
                )
            
            // Info
            VStack(alignment: .leading, spacing: 4) {
                Text(reward.name)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(colorScheme == .dark ? .white : .primary)
                
                Text(reward.description)
                    .font(.system(size: 13))
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
            }
            
            Spacer()
            
            // Price & Button
            VStack(spacing: 8) {
                HStack(spacing: 4) {
                    Image(systemName: "star.fill")
                        .font(.system(size: 12))
                        .foregroundStyle(.yellow)
                    Text("\(reward.pointsCost)")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundStyle(canAfford ? .green : .red)
                }
                
                Button(action: onRedeem) {
                    Text("Redeem")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundStyle(canAfford ? .white : .gray)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 8)
                        .background(
                            Capsule()
                                .fill(canAfford ? Color.blue : Color.gray.opacity(0.3))
                        )
                }
                .disabled(!canAfford)
            }
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(colorScheme == .dark ? Color.white.opacity(0.06) : Color.white.opacity(0.6))
                .shadow(color: .black.opacity(colorScheme == .dark ? 0.2 : 0.04), radius: 8, x: 0, y: 4)
        )
    }
}

// MARK: - History Section
struct HistorySection: View {
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(spacing: 14) {
            // Sample history items
            HistoryItem(title: "Viewed Announcement", points: "+5", time: "2 hours ago", icon: "eye.fill", color: .blue)
            HistoryItem(title: "Acknowledged Update", points: "+10", time: "3 hours ago", icon: "checkmark.circle.fill", color: .green)
            HistoryItem(title: "Daily Check-in", points: "+5", time: "Today", icon: "calendar.badge.checkmark", color: .purple)
            HistoryItem(title: "Submitted Assignment", points: "+20", time: "Yesterday", icon: "doc.badge.arrow.up.fill", color: .orange)
            HistoryItem(title: "Redeemed Reward", points: "-100", time: "3 days ago", icon: "gift.fill", color: .red, isDeduction: true)
        }
    }
}

// MARK: - History Item
struct HistoryItem: View {
    let title: String
    let points: String
    let time: String
    let icon: String
    let color: Color
    var isDeduction: Bool = false
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        HStack(spacing: 14) {
            Circle()
                .fill(color.opacity(0.15))
                .frame(width: 44, height: 44)
                .overlay(
                    Image(systemName: icon)
                        .font(.system(size: 18))
                        .foregroundStyle(color)
                )
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 15, weight: .medium))
                    .foregroundStyle(colorScheme == .dark ? .white : .primary)
                
                Text(time)
                    .font(.system(size: 12))
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            Text(points)
                .font(.system(size: 15, weight: .bold))
                .foregroundStyle(isDeduction ? .red : .green)
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(colorScheme == .dark ? Color.white.opacity(0.06) : Color.white.opacity(0.6))
        )
    }
}

// MARK: - Redeem Sheet
struct RedeemSheet: View {
    let reward: Reward
    let userPoints: Int
    let onConfirm: () -> Void
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(spacing: 24) {
            // Header
            HStack {
                Spacer()
                Button(action: { dismiss() }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 28))
                        .foregroundStyle(.gray.opacity(0.5))
                }
            }
            
            // Reward Icon
            RoundedRectangle(cornerRadius: 24)
                .fill(reward.color.opacity(0.15))
                .frame(width: 100, height: 100)
                .overlay(
                    Image(systemName: reward.icon)
                        .font(.system(size: 48))
                        .foregroundStyle(reward.color)
                )
            
            // Info
            VStack(spacing: 8) {
                Text(reward.name)
                    .font(.system(size: 24, weight: .bold))
                    .foregroundStyle(colorScheme == .dark ? .white : .primary)
                
                Text(reward.description)
                    .font(.system(size: 15))
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
            
            // Points Display
            VStack(spacing: 8) {
                HStack(spacing: 8) {
                    Image(systemName: "star.fill")
                        .foregroundStyle(.yellow)
                    Text("\(reward.pointsCost) points")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundStyle(colorScheme == .dark ? .white : .primary)
                }
                
                Text("Your balance: \(userPoints) points")
                    .font(.system(size: 14))
                    .foregroundStyle(.secondary)
                
                Text("After: \(userPoints - reward.pointsCost) points")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(.green)
            }
            .padding(20)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(colorScheme == .dark ? Color.white.opacity(0.08) : Color.gray.opacity(0.1))
            )
            
            // Confirm Button
            Button(action: onConfirm) {
                Text("Confirm Redemption")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(
                        RoundedRectangle(cornerRadius: 14)
                            .fill(Color.blue)
                            .shadow(color: Color.blue.opacity(0.4), radius: 12, x: 0, y: 6)
                    )
            }
            
            Spacer()
        }
        .padding(24)
        .presentationDetents([.medium])
    }
}

// MARK: - Preview
#Preview {
    ZStack {
        LinearGradient(
            colors: [Color.purple.opacity(0.3), Color.blue.opacity(0.4)],
            startPoint: .top,
            endPoint: .bottom
        )
        .ignoresSafeArea()
        
        RewardsView(isPresented: .constant(true))
    }
}
