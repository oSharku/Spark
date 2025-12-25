//
//  SettingsView.swift
//  Spark
//
//  Settings view for app preferences and configurations
//

import SwiftUI

// MARK: - Settings View
struct SettingsView: View {
    
    // MARK: - Properties
    @Binding var isPresented: Bool
    @Environment(\.colorScheme) var colorScheme
    @AppStorage("isDarkMode") private var isDarkMode = false
    @AppStorage("selectedLanguage") private var selectedLanguage = "English"
    @AppStorage("defaultFocusTimer") private var defaultFocusTimer = 25
    @AppStorage("autoIgnite") private var autoIgnite = false
    @AppStorage("syncCalendar") private var syncCalendar = true
    @AppStorage("widgetRefresh") private var widgetRefresh = true
    
    private let languages = ["English", "Spanish", "French", "German", "Chinese", "Japanese"]
    private let focusTimerOptions = [25, 45, 60]
    
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
                        // Preferences Section
                        preferencesSection
                        
                        // Productivity Section
                        productivitySection
                        
                        // Integrations Section
                        integrationsSection
                        
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
            Text("Settings")
                .font(.system(size: 32, weight: .bold))
                .foregroundStyle(.white)
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
    }
    
    // MARK: - Preferences Section
    private var preferencesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("PREFERENCES")
                .font(.system(size: 12, weight: .semibold))
                .foregroundStyle(.white.opacity(0.7))
                .padding(.leading, 4)
            
            VStack(spacing: 0) {
                // Dark Mode Toggle
                SettingsToggleRow(
                    icon: "moon.fill",
                    iconColor: .indigo,
                    title: "Dark Mode",
                    isOn: $isDarkMode
                )
                
                Divider()
                    .background(Color.white.opacity(0.1))
                
                // Language Picker
                SettingsPickerRow(
                    icon: "globe",
                    iconColor: .purple,
                    title: "Language",
                    selection: $selectedLanguage,
                    options: languages
                )
            }
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(colorScheme == .dark ? Color.white.opacity(0.08) : Color.white.opacity(0.2))
            )
        }
    }
    
    // MARK: - Productivity Section
    private var productivitySection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("PRODUCTIVITY (SPARK FEATURES)")
                .font(.system(size: 12, weight: .semibold))
                .foregroundStyle(.white.opacity(0.7))
                .padding(.leading, 4)
            
            VStack(spacing: 0) {
                // Default Focus Timer
                HStack(spacing: 14) {
                    Image(systemName: "timer")
                        .font(.system(size: 18))
                        .foregroundStyle(.orange)
                        .frame(width: 36, height: 36)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.orange.opacity(0.15))
                        )
                    
                    Text("Default Focus Timer")
                        .font(.system(size: 15, weight: .medium))
                        .foregroundStyle(.white)
                    
                    Spacer()
                    
                    Picker("", selection: $defaultFocusTimer) {
                        ForEach(focusTimerOptions, id: \.self) { minutes in
                            Text("\(minutes) min").tag(minutes)
                        }
                    }
                    .pickerStyle(.menu)
                    .tint(.white)
                }
                .padding(14)
                
                Divider()
                    .background(Color.white.opacity(0.1))
                
                // Auto-Ignite Toggle
                SettingsToggleRow(
                    icon: "bolt.fill",
                    iconColor: .yellow,
                    title: "Auto-Ignite",
                    isOn: $autoIgnite
                )
            }
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(colorScheme == .dark ? Color.white.opacity(0.08) : Color.white.opacity(0.2))
            )
        }
    }
    
    // MARK: - Integrations Section
    private var integrationsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("INTEGRATIONS")
                .font(.system(size: 12, weight: .semibold))
                .foregroundStyle(.white.opacity(0.7))
                .padding(.leading, 4)
            
            VStack(spacing: 0) {
                // Sync Calendar
                SettingsToggleRow(
                    icon: "calendar.badge.clock",
                    iconColor: .blue,
                    title: "Sync Calendar",
                    isOn: $syncCalendar
                )
                
                Divider()
                    .background(Color.white.opacity(0.1))
                
                // Widget Refresh
                SettingsToggleRow(
                    icon: "arrow.triangle.2.circlepath",
                    iconColor: .green,
                    title: "Widget Refresh",
                    isOn: $widgetRefresh
                )
            }
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(colorScheme == .dark ? Color.white.opacity(0.08) : Color.white.opacity(0.2))
            )
        }
    }
}

// MARK: - Settings Toggle Row
struct SettingsToggleRow: View {
    let icon: String
    let iconColor: Color
    let title: String
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
            
            Text(title)
                .font(.system(size: 15, weight: .medium))
                .foregroundStyle(.white)
            
            Spacer()
            
            Toggle("", isOn: $isOn)
                .labelsHidden()
                .tint(.blue)
        }
        .padding(14)
    }
}

// MARK: - Settings Picker Row
struct SettingsPickerRow: View {
    let icon: String
    let iconColor: Color
    let title: String
    @Binding var selection: String
    let options: [String]
    
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
            
            Text(title)
                .font(.system(size: 15, weight: .medium))
                .foregroundStyle(.white)
            
            Spacer()
            
            Picker("", selection: $selection) {
                ForEach(options, id: \.self) { option in
                    Text(option).tag(option)
                }
            }
            .pickerStyle(.menu)
            .tint(.white)
        }
        .padding(14)
    }
}

// MARK: - Preview
#Preview {
    SettingsView(isPresented: .constant(true))
}
