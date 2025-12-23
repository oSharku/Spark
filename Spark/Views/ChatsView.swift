//
//  ChatsView.swift
//  Spark
//
//  Created by STDC_34 on 18/12/2025.
//

import SwiftUI

// MARK: - Chats View
struct ChatsView: View {
    
    // MARK: - State Properties
    @State private var searchText: String = ""
    @State private var selectedSegment: ChatSegment = .all
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 20) {
                // Header
                ChatsHeaderView()
                
                // Search Bar
                ChatsSearchBar(searchText: $searchText)
                
                // Segment Filter
                ChatsSegmentFilter(selectedSegment: $selectedSegment)
                
                // Online Now Section
                ChatsOnlineNowSection()
                
                // Chat List
                ChatsListSection()
                
                // Spacer for tab bar
                Color.clear.frame(height: 100)
            }
            .padding(.horizontal, 20)
        }
    }
}

// MARK: - Chat Segment
enum ChatSegment: String, CaseIterable {
    case all = "All"
    case lecturers = "Lecturers"
    case groups = "Groups"
    case announcements = "Announcements"
}

// MARK: - Chats Header View
struct ChatsHeaderView: View {
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Chats")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundStyle(colorScheme == .dark ? .white : .primary)
                
                Text("Stay connected")
                    .font(.system(size: 15))
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            // New Chat Button
            Button(action: {}) {
                Image(systemName: "square.and.pencil")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundStyle(.blue)
                    .frame(width: 44, height: 44)
                    .background(RoundedRectangle(cornerRadius: 14).fill(.ultraThinMaterial))
            }
        }
        .padding(.top, 8)
    }
}

// MARK: - Chats Search Bar
struct ChatsSearchBar: View {
    
    @Binding var searchText: String
    @FocusState private var isFocused: Bool
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(.secondary)
            
            TextField("Search conversations...", text: $searchText)
                .font(.system(size: 15))
                .focused($isFocused)
            
            if !searchText.isEmpty {
                Button(action: {
                    searchText = ""
                    isFocused = false
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 18))
                        .foregroundStyle(.gray.opacity(0.5))
                }
            }
        }
        .padding(14)
        .background(RoundedRectangle(cornerRadius: 16).fill(.ultraThinMaterial))
    }
}

// MARK: - Chats Segment Filter
struct ChatsSegmentFilter: View {
    
    @Binding var selectedSegment: ChatSegment
    @Namespace private var animation
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(ChatSegment.allCases, id: \.self) { segment in
                    Button(action: {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            selectedSegment = segment
                        }
                    }) {
                        Text(segment.rawValue)
                            .font(.system(size: 14, weight: .medium))
                            .foregroundStyle(selectedSegment == segment ? .white : (colorScheme == .dark ? .white : .primary))
                            .padding(.horizontal, 18)
                            .padding(.vertical, 10)
                            .background {
                                if selectedSegment == segment {
                                    Capsule()
                                        .fill(Color.blue)
                                        .matchedGeometryEffect(id: "chatSegment", in: animation)
                                        .shadow(color: Color.blue.opacity(0.3), radius: 8, x: 0, y: 4)
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
}

// MARK: - Chats Online Now Section
struct ChatsOnlineNowSection: View {
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Online Now")
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(colorScheme == .dark ? .white : .primary)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ChatsOnlineUserAvatar(name: "Prof. Emmet", initials: "PE", isLecturer: true)
                    ChatsOnlineUserAvatar(name: "Dr. Smith", initials: "DS", isLecturer: true)
                    ChatsOnlineUserAvatar(name: "Sarah", initials: "S", isLecturer: false)
                    ChatsOnlineUserAvatar(name: "Mike", initials: "M", isLecturer: false)
                    ChatsOnlineUserAvatar(name: "Lisa", initials: "L", isLecturer: false)
                }
            }
        }
        .padding(16)
        .background(RoundedRectangle(cornerRadius: 20).fill(.ultraThinMaterial))
    }
}

// MARK: - Chats Online User Avatar
struct ChatsOnlineUserAvatar: View {
    
    let name: String
    let initials: String
    let isLecturer: Bool
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(spacing: 8) {
            ZStack(alignment: .bottomTrailing) {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: isLecturer ? [.green.opacity(0.6), .teal.opacity(0.6)] : [.blue.opacity(0.6), .purple.opacity(0.6)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 50, height: 50)
                    .overlay(
                        Text(initials)
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundStyle(.white)
                    )
                    .shadow(color: (isLecturer ? Color.green : Color.blue).opacity(0.3), radius: 6, x: 0, y: 3)
                
                // Online indicator
                Circle()
                    .fill(.green)
                    .frame(width: 14, height: 14)
                    .overlay(
                        Circle()
                            .stroke(.white, lineWidth: 2)
                    )
            }
            
            Text(name.components(separatedBy: " ").first ?? name)
                .font(.system(size: 11))
                .foregroundStyle(.secondary)
                .lineLimit(1)
        }
        .frame(width: 60)
    }
}

// MARK: - Chats List Section
struct ChatsListSection: View {
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(spacing: 0) {
            ChatsListItem(
                name: "Prof. Emmet",
                message: "Thank you for submitting your project!",
                time: "10:30 AM",
                unreadCount: 2,
                isOnline: true,
                isLecturer: true,
                avatarColor: .green
            )
            
            ChatsDivider()
            
            ChatsListItem(
                name: "HCI Study Group",
                message: "Sarah: Anyone has the notes for chapter 5?",
                time: "9:15 AM",
                unreadCount: 5,
                isOnline: false,
                isLecturer: false,
                avatarColor: .purple,
                isGroup: true
            )
            
            ChatsDivider()
            
            ChatsListItem(
                name: "Dr. Parker",
                message: "The lab will be rescheduled to Friday",
                time: "Yesterday",
                unreadCount: 0,
                isOnline: false,
                isLecturer: true,
                avatarColor: .green
            )
            
            ChatsDivider()
            
            ChatsListItem(
                name: "Web Dev Project Team",
                message: "You: I'll push the changes tonight",
                time: "Yesterday",
                unreadCount: 0,
                isOnline: false,
                isLecturer: false,
                avatarColor: .orange,
                isGroup: true
            )
            
            ChatsDivider()
            
            ChatsListItem(
                name: "Class Rep - CSC 3104",
                message: "Reminder: Assignment due on Friday!",
                time: "Mon",
                unreadCount: 0,
                isOnline: false,
                isLecturer: false,
                avatarColor: .red,
                isAnnouncement: true
            )
            
            ChatsDivider()
            
            ChatsListItem(
                name: "Dr. Smith",
                message: "Your database ER diagram looks good",
                time: "Mon",
                unreadCount: 1,
                isOnline: true,
                isLecturer: true,
                avatarColor: .green
            )
        }
        .background(RoundedRectangle(cornerRadius: 20).fill(.ultraThinMaterial))
    }
}

// MARK: - Chats Divider
struct ChatsDivider: View {
    var body: some View {
        Divider()
            .padding(.leading, 76)
    }
}

// MARK: - Chats List Item
struct ChatsListItem: View {
    
    let name: String
    let message: String
    let time: String
    let unreadCount: Int
    let isOnline: Bool
    let isLecturer: Bool
    let avatarColor: Color
    var isGroup: Bool = false
    var isAnnouncement: Bool = false
    
    @State private var isPressed: Bool = false
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        HStack(spacing: 14) {
            // Avatar
            ZStack(alignment: .bottomTrailing) {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: isLecturer ? [.green.opacity(0.6), .teal.opacity(0.6)] : [avatarColor.opacity(0.6), avatarColor.opacity(0.8)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 52, height: 52)
                    .overlay(
                        Group {
                            if isGroup {
                                Image(systemName: "person.3.fill")
                                    .font(.system(size: 18))
                                    .foregroundStyle(.white)
                            } else if isAnnouncement {
                                Image(systemName: "megaphone.fill")
                                    .font(.system(size: 18))
                                    .foregroundStyle(.white)
                            } else {
                                Text(String(name.prefix(1)))
                                    .font(.system(size: 20, weight: .semibold))
                                    .foregroundStyle(.white)
                            }
                        }
                    )
                    .shadow(color: avatarColor.opacity(0.2), radius: 6, x: 0, y: 3)
                
                // Online/Role Indicator
                if isOnline {
                    Circle()
                        .fill(.green)
                        .frame(width: 14, height: 14)
                        .overlay(
                            Circle()
                                .stroke(.white, lineWidth: 2)
                        )
                }
            }
            
            // Content
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(name)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(colorScheme == .dark ? .white : .primary)
                    
                    // Role Badge
                    if isLecturer {
                        Text("Lecturer")
                            .font(.system(size: 9, weight: .bold))
                            .foregroundStyle(.green)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(
                                Capsule()
                                    .fill(Color.green.opacity(0.12))
                            )
                    } else if !isGroup && !isAnnouncement {
                        Text("Student")
                            .font(.system(size: 9, weight: .bold))
                            .foregroundStyle(.blue)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(
                                Capsule()
                                    .fill(Color.blue.opacity(0.12))
                            )
                    }
                    
                    Spacer()
                    
                    Text(time)
                        .font(.system(size: 12))
                        .foregroundStyle(.secondary)
                }
                
                HStack {
                    Text(message)
                        .font(.system(size: 14))
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                    
                    Spacer()
                    
                    if unreadCount > 0 {
                        Text("\(unreadCount)")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundStyle(.white)
                            .frame(width: 22, height: 22)
                            .background(
                                Circle()
                                    .fill(Color.blue)
                            )
                    }
                }
            }
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(unreadCount > 0 ? Color.blue.opacity(colorScheme == .dark ? 0.1 : 0.03) : Color.clear)
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

// MARK: - Preview
#Preview {
    ChatsView()
        .background(SparkBackground())
}
