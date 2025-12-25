//
//  SideMenuView.swift
//  Spark
//
//  Created by STDC_34 on 18/12/2025.
//

import SwiftUI

// MARK: - Side Menu View
struct SideMenuView: View {
    
    @Binding var isPresented: Bool
    @Binding var isDarkMode: Bool
    @Binding var showRewardsPage: Bool
    @Binding var showProfilePage: Bool
    @Binding var showSettingsPage: Bool
    @Binding var showNotificationsPage: Bool
    @Binding var showHelpSupportPage: Bool
    @Binding var showAboutPage: Bool
    @StateObject private var appState = AppState.shared
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ZStack(alignment: .leading) {
            // Dimmed Background
            Color.black
                .opacity(isPresented ? 0.4 : 0)
                .ignoresSafeArea()
                .onTapGesture {
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                        isPresented = false
                    }
                }
            
            // Menu Content
            HStack(spacing: 0) {
                VStack(alignment: .leading, spacing: 0) {
                    // Header
                    MenuHeader()
                    
                    // Menu Items
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 8) {
                            // Profile Section
                            MenuSection(title: "Account") {
                                MenuItem(
                                    icon: "person.circle.fill",
                                    title: "Profile",
                                    subtitle: "View and edit your profile",
                                    color: .blue
                                ) {
                                    showProfilePage = true; isPresented = false
                                }
                                
                                MenuItem(
                                    icon: "gift.fill",
                                    title: "Rewards",
                                    subtitle: "\(appState.currentUser.points) points available",
                                    color: .orange,
                                    badge: "\(appState.currentUser.points)"
                                ) {
                                    showRewardsPage = true; isPresented = false
                                }
                            }
                            
                            // Preferences Section
                            MenuSection(title: "Preferences") {
                                // Dark Mode Toggle
                                DarkModeToggle(isDarkMode: $isDarkMode)
                                
                                MenuItem(
                                    icon: "bell.badge.fill",
                                    title: "Notifications",
                                    subtitle: "Manage alerts",
                                    color: .red
                                ) {
                                    showNotificationsPage = true; isPresented = false
                                }
                                
                                MenuItem(
                                    icon: "globe",
                                    title: "Language",
                                    subtitle: "English",
                                    color: .purple
                                ) {
                                    // Navigate to language settings
                                }
                            }
                            
                            // App Section
                            MenuSection(title: "App") {
                                MenuItem(
                                    icon: "gearshape.fill",
                                    title: "Settings",
                                    subtitle: "App preferences",
                                    color: .gray
                                ) {
                                    showSettingsPage = true; isPresented = false
                                }
                                
                                MenuItem(
                                    icon: "questionmark.circle.fill",
                                    title: "Help & Support",
                                    subtitle: "Get assistance",
                                    color: .green
                                ) {
                                    showHelpSupportPage = true; isPresented = false
                                }
                                
                                MenuItem(
                                    icon: "info.circle.fill",
                                    title: "About",
                                    subtitle: "Version 1.0.0",
                                    color: .cyan
                                ) {
                                    showAboutPage = true; isPresented = false
                                }
                            }
                            
                            Spacer().frame(height: 20)
                            
                            // Logout Button
                            LogoutButton {
                                // Handle logout
                            }
                            
                            Spacer().frame(height: 40)
                        }
                        .padding(.horizontal, 20)
                    }
                }
                .frame(width: 300)
                .background(
                    ZStack {
                        // Glass effect background
                        if colorScheme == .dark {
                            Color(hex: "1C1C1E")
                        } else {
                            Color.white
                        }
                    }
                    .ignoresSafeArea()
                )
                .shadow(color: .black.opacity(0.2), radius: 20, x: 10, y: 0)
                .offset(x: isPresented ? 0 : -320)
                
                Spacer()
            }
        }
        .animation(.spring(response: 0.35, dampingFraction: 0.8), value: isPresented)
    }
}

// MARK: - Menu Header
struct MenuHeader: View {
    @StateObject private var appState = AppState.shared
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Profile
            HStack(spacing: 14) {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [Color.blue.opacity(0.7), Color.purple.opacity(0.7)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 60, height: 60)
                    .overlay(
                        Text("J")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundStyle(.white)
                    )
                    .shadow(color: .blue.opacity(0.3), radius: 10, x: 0, y: 5)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("John Doe")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundStyle(colorScheme == .dark ? .white : .primary)
                    
                    Text("john.doe@university.edu")
                        .font(.system(size: 13))
                        .foregroundStyle(.secondary)
                    
                    // Streak Badge
                    HStack(spacing: 4) {
                        Image(systemName: "flame.fill")
                            .font(.system(size: 12))
                            .foregroundStyle(.orange)
                        Text("7 day streak")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundStyle(.orange)
                    }
                    .padding(.top, 2)
                }
            }
            
            // Stats
            HStack(spacing: 0) {
                StatItem(value: "5", label: "Classes")
                StatItem(value: "7", label: "Pending")
                StatItem(value: "\(appState.currentUser.points)", label: "Points")
            }
            .padding(.vertical, 14)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(colorScheme == .dark ? Color.white.opacity(0.08) : Color.black.opacity(0.04))
            )
        }
        .padding(20)
        .padding(.top, 50)
        .background(
            LinearGradient(
                colors: colorScheme == .dark
                    ? [Color.blue.opacity(0.2), Color.purple.opacity(0.1)]
                    : [Color.blue.opacity(0.1), Color.purple.opacity(0.05)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
    }
}

// MARK: - Stat Item
struct StatItem: View {
    let value: String
    let label: String
    
    var body: some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.system(size: 18, weight: .bold, design: .rounded))
                .foregroundStyle(.primary)
            Text(label)
                .font(.system(size: 11))
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - Menu Section
struct MenuSection<Content: View>: View {
    let title: String
    @ViewBuilder let content: Content
    @StateObject private var appState = AppState.shared
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title.uppercased())
                .font(.system(size: 12, weight: .semibold))
                .foregroundStyle(.secondary)
                .padding(.leading, 4)
                .padding(.top, 16)
            
            VStack(spacing: 4) {
                content
            }
            .padding(8)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(colorScheme == .dark ? Color.white.opacity(0.06) : Color.black.opacity(0.03))
            )
        }
    }
}

// MARK: - Menu Item
struct MenuItem: View {
    let icon: String
    let title: String
    let subtitle: String
    let color: Color
    var badge: String? = nil
    let action: () -> Void
    
    @StateObject private var appState = AppState.shared
    @Environment(\.colorScheme) var colorScheme
    @State private var isPressed = false
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 14) {
                // Icon
                Image(systemName: icon)
                    .font(.system(size: 18))
                    .foregroundStyle(color)
                    .frame(width: 36, height: 36)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(color.opacity(0.15))
                    )
                
                // Text
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(colorScheme == .dark ? .white : .primary)
                    
                    Text(subtitle)
                        .font(.system(size: 12))
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
                
                // Badge or Arrow
                if let badge = badge {
                    Text(badge)
                        .font(.system(size: 12, weight: .bold))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(
                            Capsule()
                                .fill(color)
                        )
                } else {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundStyle(.gray.opacity(0.5))
                }
            }
            .padding(10)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isPressed ? (colorScheme == .dark ? Color.white.opacity(0.1) : Color.black.opacity(0.05)) : Color.clear)
            )
        }
        .buttonStyle(.plain)
        .scaleEffect(isPressed ? 0.98 : 1.0)
        .onLongPressGesture(minimumDuration: .infinity, pressing: { pressing in
            withAnimation(.easeInOut(duration: 0.15)) {
                isPressed = pressing
            }
        }, perform: {})
    }
}

// MARK: - Dark Mode Toggle
struct DarkModeToggle: View {
    @Binding var isDarkMode: Bool
    @StateObject private var appState = AppState.shared
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        HStack(spacing: 14) {
            // Icon
            Image(systemName: isDarkMode ? "moon.fill" : "sun.max.fill")
                .font(.system(size: 18))
                .foregroundStyle(isDarkMode ? .indigo : .yellow)
                .frame(width: 36, height: 36)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill((isDarkMode ? Color.indigo : Color.yellow).opacity(0.15))
                )
            
            // Text
            VStack(alignment: .leading, spacing: 2) {
                Text("Appearance")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(colorScheme == .dark ? .white : .primary)
                
                Text(isDarkMode ? "Dark mode" : "Light mode")
                    .font(.system(size: 12))
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            // Toggle
            Toggle("", isOn: $isDarkMode)
                .labelsHidden()
                .tint(.blue)
        }
        .padding(10)
    }
}

// MARK: - Logout Button
struct LogoutButton: View {
    let action: () -> Void
    @StateObject private var appState = AppState.shared
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 10) {
                Image(systemName: "rectangle.portrait.and.arrow.right")
                    .font(.system(size: 16, weight: .medium))
                Text("Sign Out")
                    .font(.system(size: 15, weight: .semibold))
            }
            .foregroundStyle(.red)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(Color.red.opacity(0.1))
            )
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Preview
#Preview {
    SideMenuView(
        isPresented: .constant(true),
        isDarkMode: .constant(false),
        showRewardsPage: .constant(false),
        showProfilePage: .constant(false),
        showSettingsPage: .constant(false),
        showNotificationsPage: .constant(false),
        showHelpSupportPage: .constant(false),
        showAboutPage: .constant(false)
    )
}
