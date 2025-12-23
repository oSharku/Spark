//
//  FullCalendarView.swift
//  Spark
//
//  Created by STDC_34 on 18/12/2025.
//

import SwiftUI

// MARK: - Full Calendar View (Tab)
struct FullCalendarView: View {
    
    // MARK: - State Properties
    @State private var selectedDate: Date = Date()
    @State private var currentMonth: Date = Date()
    @Environment(\.colorScheme) var colorScheme
    
    // Events storage
    private let calendarEvents = CalendarEventsData.allEvents
    
    // Get events for selected date
    private var eventsForSelectedDate: [CalendarEventItem] {
        calendarEvents.filter { event in
            Calendar.current.isDate(event.date, inSameDayAs: selectedDate)
        }
    }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 24) {
                // Header
                FullCalendarHeader(currentMonth: $currentMonth)
                
                // Month Calendar
                FullMonthCalendar(
                    selectedDate: $selectedDate,
                    currentMonth: $currentMonth,
                    events: calendarEvents
                )
                
                // Selected Date Schedule
                SelectedDateSchedule(
                    selectedDate: selectedDate,
                    events: eventsForSelectedDate
                )
                
                // Upcoming Deadlines
                CalendarDeadlinesSection(events: calendarEvents)
                
                // Spacer for tab bar
                Color.clear.frame(height: 100)
            }
            .padding(.horizontal, 20)
        }
    }
}

// MARK: - Calendar Event Item
struct CalendarEventItem: Identifiable {
    let id = UUID()
    let title: String
    let date: Date
    let startTime: String
    let endTime: String?
    let location: String
    let type: CalendarEventKind
    let course: String?
    
    enum CalendarEventKind {
        case lecture, lab, assignment, exam, meeting, club, personal
        
        var icon: String {
            switch self {
            case .lecture: return "book.fill"
            case .lab: return "laptopcomputer"
            case .assignment: return "doc.text.fill"
            case .exam: return "pencil.and.ruler.fill"
            case .meeting: return "person.3.fill"
            case .club: return "flag.fill"
            case .personal: return "person.fill"
            }
        }
        
        var color: Color {
            switch self {
            case .lecture: return .purple
            case .lab: return .orange
            case .assignment: return .blue
            case .exam: return .red
            case .meeting: return .green
            case .club: return .cyan
            case .personal: return .gray
            }
        }
    }
}

// MARK: - Calendar Events Data
struct CalendarEventsData {
    static var allEvents: [CalendarEventItem] {
        let calendar = Calendar.current
        var events: [CalendarEventItem] = []
        
        // December 2025 events - dynamically generated
        let dec2025 = calendar.date(from: DateComponents(year: 2025, month: 12, day: 1))!
        
        // Week 1 (Dec 1-7)
        events.append(contentsOf: [
            CalendarEventItem(title: "HCI Lecture", date: calendar.date(byAdding: .day, value: 0, to: dec2025)!, startTime: "10:00 AM", endTime: "12:00 PM", location: "Room 301", type: .lecture, course: "CSC 3104"),
            CalendarEventItem(title: "Web Dev Lab", date: calendar.date(byAdding: .day, value: 1, to: dec2025)!, startTime: "2:00 PM", endTime: "4:00 PM", location: "Computer Lab A", type: .lab, course: "CSC 2201"),
            CalendarEventItem(title: "Database Quiz", date: calendar.date(byAdding: .day, value: 2, to: dec2025)!, startTime: "9:00 AM", endTime: "10:00 AM", location: "Hall A", type: .exam, course: "CSC 2105"),
            CalendarEventItem(title: "Study Group", date: calendar.date(byAdding: .day, value: 3, to: dec2025)!, startTime: "3:00 PM", endTime: "5:00 PM", location: "Library", type: .meeting, course: nil),
            CalendarEventItem(title: "Software Engineering", date: calendar.date(byAdding: .day, value: 4, to: dec2025)!, startTime: "11:00 AM", endTime: "1:00 PM", location: "Room 401", type: .lecture, course: "CSC 3201"),
        ])
        
        // Week 2 (Dec 8-14)
        events.append(contentsOf: [
            CalendarEventItem(title: "Mobile Dev Lab", date: calendar.date(byAdding: .day, value: 7, to: dec2025)!, startTime: "3:00 PM", endTime: "5:00 PM", location: "Lab B", type: .lab, course: "CSC 3105"),
            CalendarEventItem(title: "Tech Club Meeting", date: calendar.date(byAdding: .day, value: 8, to: dec2025)!, startTime: "4:00 PM", endTime: "5:30 PM", location: "Room 201", type: .club, course: nil),
            CalendarEventItem(title: "Project Presentation", date: calendar.date(byAdding: .day, value: 9, to: dec2025)!, startTime: "10:00 AM", endTime: "12:00 PM", location: "Seminar Hall", type: .assignment, course: "CSC 3104"),
            CalendarEventItem(title: "HCI Lecture", date: calendar.date(byAdding: .day, value: 10, to: dec2025)!, startTime: "10:00 AM", endTime: "12:00 PM", location: "Room 301", type: .lecture, course: "CSC 3104"),
            CalendarEventItem(title: "Web Dev Project Due", date: calendar.date(byAdding: .day, value: 11, to: dec2025)!, startTime: "11:59 PM", endTime: nil, location: "Online", type: .assignment, course: "CSC 2201"),
        ])
        
        // Week 3 (Dec 15-21)
        events.append(contentsOf: [
            CalendarEventItem(title: "HCI Lecture", date: calendar.date(byAdding: .day, value: 14, to: dec2025)!, startTime: "10:00 AM", endTime: "12:00 PM", location: "Room 301", type: .lecture, course: "CSC 3104"),
            CalendarEventItem(title: "Web Dev Lab", date: calendar.date(byAdding: .day, value: 14, to: dec2025)!, startTime: "2:00 PM", endTime: "4:00 PM", location: "Computer Lab A", type: .lab, course: "CSC 2201"),
            CalendarEventItem(title: "Database Quiz", date: calendar.date(byAdding: .day, value: 15, to: dec2025)!, startTime: "9:00 AM", endTime: "10:00 AM", location: "Hall A", type: .exam, course: "CSC 2105"),
            CalendarEventItem(title: "Project Meeting", date: calendar.date(byAdding: .day, value: 16, to: dec2025)!, startTime: "3:00 PM", endTime: "4:00 PM", location: "Library", type: .meeting, course: "CSC 3104"),
            CalendarEventItem(title: "Lab Report Due", date: calendar.date(byAdding: .day, value: 16, to: dec2025)!, startTime: "11:59 PM", endTime: nil, location: "Online", type: .assignment, course: "CSC 2201"),
            CalendarEventItem(title: "AR App Presentation", date: calendar.date(byAdding: .day, value: 17, to: dec2025)!, startTime: "10:00 AM", endTime: "12:00 PM", location: "Seminar Hall", type: .lecture, course: "CSC 3104"),
            CalendarEventItem(title: "JavaScript Assignment", date: calendar.date(byAdding: .day, value: 17, to: dec2025)!, startTime: "5:00 PM", endTime: nil, location: "Online", type: .assignment, course: "CSC 2201"),
            CalendarEventItem(title: "Study Group", date: calendar.date(byAdding: .day, value: 17, to: dec2025)!, startTime: "7:00 PM", endTime: "9:00 PM", location: "Library", type: .meeting, course: nil),
            CalendarEventItem(title: "Software Engineering", date: calendar.date(byAdding: .day, value: 18, to: dec2025)!, startTime: "11:00 AM", endTime: "1:00 PM", location: "Room 401", type: .lecture, course: "CSC 3201"),
            CalendarEventItem(title: "Mobile Dev Lab", date: calendar.date(byAdding: .day, value: 18, to: dec2025)!, startTime: "3:00 PM", endTime: "5:00 PM", location: "Lab B", type: .lab, course: "CSC 3105"),
            CalendarEventItem(title: "Database Final", date: calendar.date(byAdding: .day, value: 19, to: dec2025)!, startTime: "9:00 AM", endTime: "11:00 AM", location: "Hall A", type: .exam, course: "CSC 2105"),
            CalendarEventItem(title: "Web Dev Project Due", date: calendar.date(byAdding: .day, value: 19, to: dec2025)!, startTime: "11:59 PM", endTime: nil, location: "Online", type: .assignment, course: "CSC 2201"),
            CalendarEventItem(title: "Club Meeting", date: calendar.date(byAdding: .day, value: 20, to: dec2025)!, startTime: "4:00 PM", endTime: "5:30 PM", location: "Room 201", type: .club, course: nil),
        ])
        
        // Week 4 (Dec 22-28)
        events.append(contentsOf: [
            CalendarEventItem(title: "HCI Final Exam", date: calendar.date(byAdding: .day, value: 21, to: dec2025)!, startTime: "2:00 PM", endTime: "4:00 PM", location: "Hall B", type: .exam, course: "CSC 3104"),
            CalendarEventItem(title: "Software Eng Presentation", date: calendar.date(byAdding: .day, value: 22, to: dec2025)!, startTime: "10:00 AM", endTime: "12:00 PM", location: "Seminar Hall", type: .assignment, course: "CSC 3201"),
            CalendarEventItem(title: "Web Dev Final", date: calendar.date(byAdding: .day, value: 23, to: dec2025)!, startTime: "9:00 AM", endTime: "11:00 AM", location: "Computer Lab A", type: .exam, course: "CSC 2201"),
            CalendarEventItem(title: "Christmas Eve Party", date: calendar.date(byAdding: .day, value: 23, to: dec2025)!, startTime: "6:00 PM", endTime: "10:00 PM", location: "Student Hall", type: .club, course: nil),
            CalendarEventItem(title: "Mobile Dev Final", date: calendar.date(byAdding: .day, value: 26, to: dec2025)!, startTime: "2:00 PM", endTime: "4:00 PM", location: "Lab B", type: .exam, course: "CSC 3105"),
        ])
        
        return events
    }
}

// MARK: - Full Calendar Header
struct FullCalendarHeader: View {
    
    @Binding var currentMonth: Date
    @Environment(\.colorScheme) var colorScheme
    
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
                    .foregroundStyle(colorScheme == .dark ? .white : .primary)
                
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

// MARK: - Full Month Calendar
struct FullMonthCalendar: View {
    
    @Binding var selectedDate: Date
    @Binding var currentMonth: Date
    let events: [CalendarEventItem]
    @Environment(\.colorScheme) var colorScheme
    
    private let daysOfWeek = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    private let columns = Array(repeating: GridItem(.flexible()), count: 7)
    
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
                    .foregroundStyle(colorScheme == .dark ? .white : .primary)
                
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
                        let date = getDateForDay(day)
                        let eventColors = getEventColors(for: date)
                        
                        FullCalendarDayButton(
                            day: day,
                            isSelected: isSelectedDay(day),
                            isToday: isTodayDay(day),
                            eventColors: eventColors,
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
        .background(RoundedRectangle(cornerRadius: 24).fill(.ultraThinMaterial))
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
    
    private func getDateForDay(_ day: Int) -> Date {
        let calendar = Calendar.current
        var components = calendar.dateComponents([.year, .month], from: currentMonth)
        components.day = day
        return calendar.date(from: components) ?? Date()
    }
    
    private func getEventColors(for date: Date) -> [Color] {
        let dayEvents = events.filter { Calendar.current.isDate($0.date, inSameDayAs: date) }
        return Array(Set(dayEvents.map { $0.type.color })).prefix(3).map { $0 }
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

// MARK: - Full Calendar Day Button
struct FullCalendarDayButton: View {
    
    let day: Int
    let isSelected: Bool
    let isToday: Bool
    let eventColors: [Color]
    let action: () -> Void
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Text("\(day)")
                    .font(.system(size: 16, weight: isToday || isSelected ? .bold : .medium))
                    .foregroundStyle(isSelected ? .white : (isToday ? .blue : (colorScheme == .dark ? .white : .primary)))
                
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

// MARK: - Selected Date Schedule
struct SelectedDateSchedule: View {
    
    let selectedDate: Date
    let events: [CalendarEventItem]
    @Environment(\.colorScheme) var colorScheme
    
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
                        .foregroundStyle(colorScheme == .dark ? .white : .primary)
                    
                    Text(formattedDate)
                        .font(.system(size: 13))
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
                
                Button("Add") {}
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(.blue)
            }
            
            // Events
            if events.isEmpty {
                // Empty State
                VStack(spacing: 12) {
                    Image(systemName: "calendar.badge.exclamationmark")
                        .font(.system(size: 40))
                        .foregroundStyle(.gray.opacity(0.5))
                    
                    Text("No events scheduled")
                        .font(.system(size: 15, weight: .medium))
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 30)
            } else {
                VStack(spacing: 12) {
                    ForEach(events) { event in
                        ScheduleEventCard(event: event)
                    }
                }
            }
        }
        .padding(20)
        .background(RoundedRectangle(cornerRadius: 24).fill(.ultraThinMaterial))
    }
}

// MARK: - Schedule Event Card
struct ScheduleEventCard: View {
    
    let event: CalendarEventItem
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        HStack(spacing: 14) {
            // Time Line
            RoundedRectangle(cornerRadius: 2)
                .fill(event.type.color)
                .frame(width: 4)
            
            // Icon
            Circle()
                .fill(event.type.color.opacity(0.15))
                .frame(width: 44, height: 44)
                .overlay(
                    Image(systemName: event.type.icon)
                        .font(.system(size: 18))
                        .foregroundStyle(event.type.color)
                )
            
            // Content
            VStack(alignment: .leading, spacing: 4) {
                Text(event.title)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(colorScheme == .dark ? .white : .primary)
                
                HStack(spacing: 12) {
                    HStack(spacing: 4) {
                        Image(systemName: "clock")
                            .font(.system(size: 10))
                        Text(event.endTime != nil ? "\(event.startTime) - \(event.endTime!)" : event.startTime)
                            .font(.system(size: 12))
                    }
                    
                    HStack(spacing: 4) {
                        Image(systemName: "location")
                            .font(.system(size: 10))
                        Text(event.location)
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
                .fill(colorScheme == .dark ? Color.white.opacity(0.06) : Color.white.opacity(0.6))
                .shadow(color: .black.opacity(colorScheme == .dark ? 0.2 : 0.04), radius: 8, x: 0, y: 4)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(event.type.color.opacity(0.2), lineWidth: 1)
        )
    }
}

// MARK: - Calendar Deadlines Section
struct CalendarDeadlinesSection: View {
    
    let events: [CalendarEventItem]
    @Environment(\.colorScheme) var colorScheme
    
    private var upcomingDeadlines: [CalendarEventItem] {
        let now = Date()
        return events
            .filter { $0.type == .assignment || $0.type == .exam }
            .filter { $0.date > now }
            .sorted { $0.date < $1.date }
            .prefix(4)
            .map { $0 }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Header
            HStack {
                Text("Upcoming Deadlines")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundStyle(colorScheme == .dark ? .white : .primary)
                
                Spacer()
                
                Button("See all") {}
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(.blue)
            }
            
            // Deadline Items
            VStack(spacing: 10) {
                ForEach(upcomingDeadlines) { event in
                    CalendarDeadlineItem(event: event)
                }
            }
        }
        .padding(20)
        .background(RoundedRectangle(cornerRadius: 24).fill(.ultraThinMaterial))
    }
}

// MARK: - Calendar Deadline Item
struct CalendarDeadlineItem: View {
    
    let event: CalendarEventItem
    @Environment(\.colorScheme) var colorScheme
    
    private var daysLeft: Int {
        let calendar = Calendar.current
        return calendar.dateComponents([.day], from: Date(), to: event.date).day ?? 0
    }
    
    private var urgencyColor: Color {
        if daysLeft <= 1 { return .red }
        else if daysLeft <= 3 { return .orange }
        else { return .blue }
    }
    
    private var dateString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        return formatter.string(from: event.date)
    }
    
    var body: some View {
        HStack(spacing: 14) {
            // Days Left Badge
            VStack(spacing: 2) {
                Text("\(max(daysLeft, 0))")
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
                Text(event.title)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(colorScheme == .dark ? .white : .primary)
                    .lineLimit(1)
                
                HStack(spacing: 8) {
                    if let course = event.course {
                        Text(course)
                            .font(.system(size: 12))
                            .foregroundStyle(.secondary)
                    }
                    
                    Text("•")
                        .foregroundStyle(.secondary)
                    
                    Text(dateString)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundStyle(urgencyColor)
                }
            }
            
            Spacer()
            
            if daysLeft <= 1 {
                Image(systemName: "exclamationmark.circle.fill")
                    .font(.system(size: 20))
                    .foregroundStyle(.red)
            }
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(daysLeft <= 1 ? Color.red.opacity(0.05) : (colorScheme == .dark ? Color.white.opacity(0.04) : Color.white.opacity(0.5)))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(daysLeft <= 1 ? Color.red.opacity(0.2) : Color.clear, lineWidth: 1)
        )
    }
}

// MARK: - Preview
#Preview {
    FullCalendarView()
        .background(SparkBackground())
}
