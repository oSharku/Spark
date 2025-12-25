//
//  EventDetailView.swift
//  Spark
//
//  Detailed calendar event view with location and actions
//

import SwiftUI

// MARK: - Event Detail View
struct EventDetailView: View {
    
    let event: CalendarEventModel
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme
    
    private var dateText: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMMM d, yyyy"
        return formatter.string(from: event.date)
    }
    
    private var timeText: String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return "\(formatter.string(from: event.startTime)) - \(formatter.string(from: event.endTime))"
    }
    
    private var durationText: String {
        let duration = Int(event.endTime.timeIntervalSince(event.startTime) / 60) // minutes
        if duration < 60 {
            return "\(duration) min"
        } else {
            let hours = duration / 60
            let mins = duration % 60
            return mins > 0 ? "\(hours)h \(mins)m" : "\(hours)h"
        }
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
                                Label("Edit Event", systemImage: "pencil")
                            }
                            Button(action: {}) {
                                Label("Share", systemImage: "square.and.arrow.up")
                            }
                            Button(action: {}) {
                                Label("Set Reminder", systemImage: "bell.badge")
                            }
                            Divider()
                            Button(role: .destructive, action: {}) {
                                Label("Delete Event", systemImage: "trash")
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
                    
                    // Event Type Icon
                    VStack(spacing: 16) {
                        ZStack {
                            Circle()
                                .fill(event.color.opacity(0.15))
                                .frame(width: 80, height: 80)
                            
                            Image(systemName: event.type.icon)
                                .font(.system(size: 36))
                                .foregroundStyle(event.color)
                        }
                        .shadow(color: event.color.opacity(0.3), radius: 12, x: 0, y: 6)
                        
                        Text(event.type.rawValue)
                            .font(.system(size: 13, weight: .bold))
                            .foregroundStyle(event.color)
                            .padding(.horizontal, 14)
                            .padding(.vertical, 6)
                            .background(
                                Capsule()
                                    .fill(event.color.opacity(0.12))
                            )
                    }
                    
                    // Main Content Card
                    VStack(alignment: .leading, spacing: 20) {
                        // Title
                        Text(event.title)
                            .font(.system(size: 26, weight: .bold))
                            .foregroundStyle(colorScheme == .dark ? .white : .primary)
                        
                        // Date & Time Info
                        VStack(spacing: 16) {
                            HStack(spacing: 12) {
                                Image(systemName: "calendar")
                                    .font(.system(size: 20))
                                    .foregroundStyle(event.color)
                                    .frame(width: 40, height: 40)
                                    .background(
                                        RoundedRectangle(cornerRadius: 10)
                                            .fill(event.color.opacity(0.12))
                                    )
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Date")
                                        .font(.system(size: 11, weight: .medium))
                                        .foregroundStyle(.secondary)
                                    Text(dateText)
                                        .font(.system(size: 14, weight: .semibold))
                                        .foregroundStyle(colorScheme == .dark ? .white : .primary)
                                }
                                
                                Spacer()
                            }
                            
                            HStack(spacing: 12) {
                                Image(systemName: "clock")
                                    .font(.system(size: 20))
                                    .foregroundStyle(event.color)
                                    .frame(width: 40, height: 40)
                                    .background(
                                        RoundedRectangle(cornerRadius: 10)
                                            .fill(event.color.opacity(0.12))
                                    )
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Time")
                                        .font(.system(size: 11, weight: .medium))
                                        .foregroundStyle(.secondary)
                                    Text("\(timeText) • \(durationText)")
                                        .font(.system(size: 14, weight: .semibold))
                                        .foregroundStyle(colorScheme == .dark ? .white : .primary)
                                }
                                
                                Spacer()
                            }
                            
                            HStack(spacing: 12) {
                                Image(systemName: "location.fill")
                                    .font(.system(size: 20))
                                    .foregroundStyle(event.color)
                                    .frame(width: 40, height: 40)
                                    .background(
                                        RoundedRectangle(cornerRadius: 10)
                                            .fill(event.color.opacity(0.12))
                                    )
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Location")
                                        .font(.system(size: 11, weight: .medium))
                                        .foregroundStyle(.secondary)
                                    Text(event.location)
                                        .font(.system(size: 14, weight: .semibold))
                                        .foregroundStyle(colorScheme == .dark ? .white : .primary)
                                }
                                
                                Spacer()
                                
                                Button(action: {}) {
                                    Image(systemName: "map.fill")
                                        .font(.system(size: 16))
                                        .foregroundStyle(.blue)
                                }
                            }
                        }
                        
                        Divider()
                            .background(colorScheme == .dark ? Color.white.opacity(0.1) : Color.gray.opacity(0.3))
                        
                        // Map Preview Placeholder
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Location Map")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundStyle(colorScheme == .dark ? .white : .primary)
                            
                            ZStack {
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(
                                        LinearGradient(
                                            colors: [event.color.opacity(0.2), event.color.opacity(0.1)],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .frame(height: 200)
                                
                                VStack(spacing: 12) {
                                    Image(systemName: "map.fill")
                                        .font(.system(size: 40))
                                        .foregroundStyle(event.color)
                                    
                                    Text(event.location)
                                        .font(.system(size: 14, weight: .semibold))
                                        .foregroundStyle(colorScheme == .dark ? .white : .primary)
                                    
                                    Button(action: {}) {
                                        Text("Open in Maps")
                                            .font(.system(size: 13, weight: .semibold))
                                            .foregroundStyle(.blue)
                                            .padding(.horizontal, 16)
                                            .padding(.vertical, 8)
                                            .background(
                                                Capsule()
                                                    .fill(.ultraThinMaterial)
                                            )
                                    }
                                }
                            }
                        }
                        
                        // Description
                        if !event.description.isEmpty {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Description")
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundStyle(colorScheme == .dark ? .white : .primary)
                                
                                Text(event.description)
                                    .font(.system(size: 15))
                                    .foregroundStyle(colorScheme == .dark ? .white.opacity(0.85) : .primary.opacity(0.85))
                                    .lineSpacing(4)
                            }
                        }
                        
                        // Course Info (if applicable)
                        if event.type == .lecture || event.type == .lab, let courseId = event.courseId {
                            HStack(spacing: 12) {
                                Image(systemName: "book.fill")
                                    .font(.system(size: 20))
                                    .foregroundStyle(.purple)
                                    .frame(width: 40, height: 40)
                                    .background(
                                        RoundedRectangle(cornerRadius: 10)
                                            .fill(Color.purple.opacity(0.12))
                                    )
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Course")
                                        .font(.system(size: 11, weight: .medium))
                                        .foregroundStyle(.secondary)
                                    Text("Course ID: \(courseId.uuidString.prefix(8))")
                                        .font(.system(size: 14, weight: .semibold))
                                        .foregroundStyle(colorScheme == .dark ? .white : .primary)
                                }
                                
                                Spacer()
                            }
                            .padding(14)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(colorScheme == .dark ? Color.white.opacity(0.06) : Color.gray.opacity(0.08))
                            )
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
                        Button(action: {}) {
                            HStack(spacing: 12) {
                                Image(systemName: "calendar.badge.plus")
                                    .font(.system(size: 18))
                                
                                Text("Add to System Calendar")
                                    .font(.system(size: 17, weight: .semibold))
                            }
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(
                                        LinearGradient(
                                            colors: [event.color, event.color.opacity(0.8)],
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                                    .shadow(color: event.color.opacity(0.4), radius: 12, x: 0, y: 6)
                            )
                        }
                        
                        HStack(spacing: 12) {
                            Button(action: {}) {
                                HStack(spacing: 8) {
                                    Image(systemName: "bell.badge")
                                        .font(.system(size: 16))
                                    Text("Remind Me")
                                        .font(.system(size: 15, weight: .semibold))
                                }
                                .foregroundStyle(.blue)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 14)
                                .background(
                                    RoundedRectangle(cornerRadius: 14)
                                        .fill(Color.blue.opacity(0.1))
                                )
                            }
                            
                            Button(action: {}) {
                                HStack(spacing: 8) {
                                    Image(systemName: "square.and.arrow.up")
                                        .font(.system(size: 16))
                                    Text("Share")
                                        .font(.system(size: 15, weight: .semibold))
                                }
                                .foregroundStyle(.blue)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 14)
                                .background(
                                    RoundedRectangle(cornerRadius: 14)
                                        .fill(Color.blue.opacity(0.1))
                                )
                            }
                        }
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

// MARK: - Preview
#Preview {
    NavigationStack {
        EventDetailView(
            event: CalendarEventModel(
                title: "HCI Lecture",
                description: "Introduction to Human-Computer Interaction principles and user experience design. We'll cover usability heuristics and conducting user research.",
                date: Date(),
                startTime: Date(),
                endTime: Date().addingTimeInterval(7200),
                location: "Room 301, Engineering Building",
                type: .lecture,
                colorHex: "9B59B6"
            )
        )
    }
}
