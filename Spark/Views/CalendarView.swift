//
//  CalendarView.swift
//  Spark
//
//  Created by STDC_34 on 18/12/2025.
//

import SwiftUI

// MARK: - Calendar Tab View
struct CalendarView: View {
    
    // MARK: - State Properties
    @State private var selectedDate: Date = Date()
    @State private var currentMonth: Date = Date()
    @State private var showAddEvent: Bool = false
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 24) {
                // Header
                CalendarHeader(currentMonth: $currentMonth)
                
                // Month Calendar
                MonthCalendar(
                    selectedDate: $selectedDate,
                    currentMonth: $currentMonth
                )
                
                // Today's Schedule
                TodayScheduleSection(selectedDate: selectedDate)
                
                // Upcoming Deadlines
                UpcomingDeadlinesSection()
                
                // Spacer for tab bar
                Color.clear.frame(height: 100)
            }
            .padding(.horizontal, 20)
        }
    }
}

// MARK: - Calendar Header
struct CalendarHeader: View {
    
    @Binding var currentMonth: Date
    
    private var monthYearString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: currentMonth)
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Calendar")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundStyle(.primary)
                
                Text(monthYearString)
                    .font(.system(size: 15))
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            HStack(spacing: 12) {
                // Today Button
                Button(action: {
                    withAnimation(.spring(response: 0.3)) {
                        currentMonth = Date()
                    }
                }) {
                    Text("Today")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(.blue)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 8)
                        .background(
                            Capsule()
                                .fill(Color.blue.opacity(0.12))
                        )
                }
                
                // Add Event Button
                Button(action: {}) {
                    Image(systemName: "plus")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundStyle(.white)
                        .frame(width: 44, height: 44)
                        .background(
                            RoundedRectangle(cornerRadius: 14)
                                .fill(Color.blue)
                                .shadow(color: Color.blue.opacity(0.4), radius: 12, x: 0, y: 6)
                        )
                }
            }
        }
        .padding(.top, 8)
    }
}

// MARK: - Month Calendar
struct MonthCalendar: View {
    
    @Binding var selectedDate: Date
    @Binding var currentMonth: Date
    
    private let daysOfWeek = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    private let columns = Array(repeating: GridItem(.flexible()), count: 7)
    
    // Sample events data (day: [event colors])
    private let eventDays: [Int: [Color]] = [
        11: [.red],
        12: [.purple, .blue],
        13: [.red, .orange],
        18: [.blue, .purple],
        20: [.red],
        22: [.green, .blue],
        25: [.red, .orange, .purple]
    ]
    
    var body: some View {
        VStack(spacing: 20) {
            // Month Navigation
            HStack {
                Button(action: {
                    withAnimation(.spring(response: 0.3)) {
                        changeMonth(by: -1)
                    }
                }) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(.blue)
                        .frame(width: 36, height: 36)
                        .background(
                            Circle()
                                .fill(Color.blue.opacity(0.1))
                        )
                }
                
                Spacer()
                
                Text(monthYearString)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(.primary)
                
                Spacer()
                
                Button(action: {
                    withAnimation(.spring(response: 0.3)) {
                        changeMonth(by: 1)
                    }
                }) {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(.blue)
                        .frame(width: 36, height: 36)
                        .background(
                            Circle()
                                .fill(Color.blue.opacity(0.1))
                        )
                }
            }
            
            // Days of Week Header
            LazyVGrid(columns: columns, spacing: 8) {
                ForEach(daysOfWeek, id: \.self) { day in
                    Text(day)
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundStyle(.secondary)
                        .frame(height: 30)
                }
            }
            
            // Calendar Days
            LazyVGrid(columns: columns, spacing: 8) {
                ForEach(daysInMonth(), id: \.self) { day in
                    if day > 0 {
                        CalendarDayButton(
                            day: day,
                            isSelected: isSelectedDay(day),
                            isToday: isTodayDay(day),
                            eventColors: eventDays[day] ?? [],
                            action: {
                                withAnimation(.spring(response: 0.3)) {
                                    selectDay(day)
                                }
                            }
                        )
                    } else {
                        Color.clear
                            .frame(height: 44)
                    }
                }
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(.ultraThinMaterial)
                .shadow(color: .black.opacity(0.08), radius: 16, x: 0, y: 8)
        )
    }
    
    // MARK: - Helper Functions
    
    private var monthYearString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: currentMonth)
    }
    
    private func changeMonth(by value: Int) {
        if let newMonth = Calendar.current.date(byAdding: .month, value: value, to: currentMonth) {
            currentMonth = newMonth
        }
    }
    
    private func daysInMonth() -> [Int] {
        let calendar = Calendar.current
        let range = calendar.range(of: .day, in: .month, for: currentMonth)!
        let firstDayOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: currentMonth))!
        let firstWeekday = calendar.component(.weekday, from: firstDayOfMonth)
        
        var days = Array(repeating: 0, count: firstWeekday - 1)
        days += Array(1...range.count)
        return days
    }
    
    private func isSelectedDay(_ day: Int) -> Bool {
        let calendar = Calendar.current
        let selectedDay = calendar.component(.day, from: selectedDate)
        let selectedMonth = calendar.component(.month, from: selectedDate)
        let selectedYear = calendar.component(.year, from: selectedDate)
        let currentMonthComponent = calendar.component(.month, from: currentMonth)
        let currentYearComponent = calendar.component(.year, from: currentMonth)
        return selectedDay == day && selectedMonth == currentMonthComponent && selectedYear == currentYearComponent
    }
    
    private func isTodayDay(_ day: Int) -> Bool {
        let calendar = Calendar.current
        let today = Date()
        let todayDay = calendar.component(.day, from: today)
        let todayMonth = calendar.component(.month, from: today)
        let todayYear = calendar.component(.year, from: today)
        let currentMonthComponent = calendar.component(.month, from: currentMonth)
        let currentYearComponent = calendar.component(.year, from: currentMonth)
        return todayDay == day && todayMonth == currentMonthComponent && todayYear == currentYearComponent
    }
    
    private func selectDay(_ day: Int) {
        let calendar = Calendar.current
        var components = calendar.dateComponents([.year, .month], from: currentMonth)
        components.day = day
        if let newDate = calendar.date(from: components) {
            selectedDate = newDate
        }
    }
}

// MARK: - Calendar Day Button
struct CalendarDayButton: View {
    
    let day: Int
    let isSelected: Bool
    let isToday: Bool
    let eventColors: [Color]
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Text("\(day)")
                    .font(.system(size: 16, weight: isToday || isSelected ? .bold : .medium))
                    .foregroundStyle(isSelected ? .white : (isToday ? .blue : .primary))
                
                // Event indicators
                HStack(spacing: 3) {
                    ForEach(Array(eventColors.prefix(3).enumerated()), id: \.offset) { _, color in
                        Circle()
                            .fill(isSelected ? .white : color)
                            .frame(width: 5, height: 5)
                    }
                }
                .frame(height: 6)
            }
            .frame(width: 44, height: 44)
            .background(
                Group {
                    if isSelected {
                        Circle()
                            .fill(Color.blue)
                            .shadow(color: Color.blue.opacity(0.4), radius: 8, x: 0, y: 4)
                    } else if isToday {
                        Circle()
                            .stroke(Color.blue, lineWidth: 2)
                    }
                }
            )
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Today's Schedule Section
struct TodayScheduleSection: View {
    
    let selectedDate: Date
    
    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMMM d"
        return formatter.string(from: selectedDate)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Header
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Schedule")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundStyle(.primary)
                    
                    Text(formattedDate)
                        .font(.system(size: 13))
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
                
                Button("Add") {}
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(.blue)
            }
            
            // Schedule Items
            VStack(spacing: 12) {
                ScheduleItem(
                    title: "HCI Lecture",
                    time: "10:00 AM - 12:00 PM",
                    location: "Room 301",
                    type: .lecture,
                    color: .purple
                )
                
                ScheduleItem(
                    title: "AR App Project Due",
                    time: "11:59 PM",
                    location: "Online Submission",
                    type: .assignment,
                    color: .blue
                )
                
                ScheduleItem(
                    title: "Web Dev Lab",
                    time: "2:00 PM - 4:00 PM",
                    location: "Computer Lab A",
                    type: .lab,
                    color: .orange
                )
                
                ScheduleItem(
                    title: "Study Group Meeting",
                    time: "5:00 PM - 6:00 PM",
                    location: "Library",
                    type: .meeting,
                    color: .green
                )
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(.ultraThinMaterial)
                .shadow(color: .black.opacity(0.08), radius: 16, x: 0, y: 8)
        )
    }
}

// MARK: - Schedule Event Type
enum ScheduleEventType {
    case lecture, lab, assignment, exam, meeting
    
    var icon: String {
        switch self {
        case .lecture: return "book.fill"
        case .lab: return "laptopcomputer"
        case .assignment: return "doc.text.fill"
        case .exam: return "pencil.and.ruler.fill"
        case .meeting: return "person.3.fill"
        }
    }
}

// MARK: - Schedule Item
struct ScheduleItem: View {
    
    let title: String
    let time: String
    let location: String
    let type: ScheduleEventType
    let color: Color
    
    var body: some View {
        HStack(spacing: 14) {
            // Time Line
            RoundedRectangle(cornerRadius: 2)
                .fill(color)
                .frame(width: 4)
            
            // Icon
            Circle()
                .fill(color.opacity(0.15))
                .frame(width: 44, height: 44)
                .overlay(
                    Image(systemName: type.icon)
                        .font(.system(size: 18))
                        .foregroundStyle(color)
                )
            
            // Content
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(.primary)
                
                HStack(spacing: 12) {
                    HStack(spacing: 4) {
                        Image(systemName: "clock")
                            .font(.system(size: 10))
                        Text(time)
                            .font(.system(size: 12))
                    }
                    
                    HStack(spacing: 4) {
                        Image(systemName: "location")
                            .font(.system(size: 10))
                        Text(location)
                            .font(.system(size: 12))
                    }
                }
                .foregroundStyle(.secondary)
            }
            
            Spacer()
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white.opacity(0.6))
                .shadow(color: .black.opacity(0.04), radius: 8, x: 0, y: 4)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(color.opacity(0.2), lineWidth: 1)
        )
    }
}

// MARK: - Upcoming Deadlines Section
struct UpcomingDeadlinesSection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Header
            HStack {
                Text("Upcoming Deadlines")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundStyle(.primary)
                
                Spacer()
                
                Button("See all") {}
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(.blue)
            }
            
            // Deadline Items
            VStack(spacing: 10) {
                DeadlineItem(
                    title: "JavaScript Lab Report",
                    course: "Web Development",
                    dueDate: "Dec 19",
                    daysLeft: 1,
                    isUrgent: true
                )
                
                DeadlineItem(
                    title: "Database Quiz",
                    course: "Database Systems",
                    dueDate: "Dec 20",
                    daysLeft: 2,
                    isUrgent: true
                )
                
                DeadlineItem(
                    title: "UI/UX Case Study",
                    course: "Human-Computer Interaction",
                    dueDate: "Dec 22",
                    daysLeft: 4,
                    isUrgent: false
                )
                
                DeadlineItem(
                    title: "Final Project Presentation",
                    course: "Software Engineering",
                    dueDate: "Dec 25",
                    daysLeft: 7,
                    isUrgent: false
                )
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(.ultraThinMaterial)
                .shadow(color: .black.opacity(0.08), radius: 16, x: 0, y: 8)
        )
    }
}

// MARK: - Deadline Item
struct DeadlineItem: View {
    
    let title: String
    let course: String
    let dueDate: String
    let daysLeft: Int
    let isUrgent: Bool
    
    private var urgencyColor: Color {
        if daysLeft <= 1 { return .red }
        else if daysLeft <= 3 { return .orange }
        else { return .blue }
    }
    
    var body: some View {
        HStack(spacing: 14) {
            // Days Left Badge
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
            
            // Content
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(.primary)
                    .lineLimit(1)
                
                HStack(spacing: 8) {
                    Text(course)
                        .font(.system(size: 12))
                        .foregroundStyle(.secondary)
                    
                    Text("•")
                        .foregroundStyle(.secondary)
                    
                    Text(dueDate)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundStyle(urgencyColor)
                }
            }
            
            Spacer()
            
            if isUrgent {
                Image(systemName: "exclamationmark.circle.fill")
                    .font(.system(size: 20))
                    .foregroundStyle(.red)
            }
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(isUrgent ? Color.red.opacity(0.05) : Color.white.opacity(0.5))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(isUrgent ? Color.red.opacity(0.2) : Color.clear, lineWidth: 1)
        )
    }
}

// MARK: - Preview
#Preview {
    CalendarView()
        .background(SparkBackground())
}
