//
//  AppState.swift
//  Spark
//
//  Global app state manager for the Spark student notification system
//

import SwiftUI
import Combine

// MARK: - App State Manager
@MainActor
class AppState: ObservableObject {
    
    // MARK: - Singleton
    static let shared = AppState()
    
    // MARK: - User State
    @Published var currentUser: SparkUser = SparkUser.sampleStudent
    @Published var isLoggedIn: Bool = true
    @Published var isOnboarded: Bool = true
    
    // MARK: - Announcements
    @Published var announcements: [Announcement] = []
    @Published var unreadAnnouncementCount: Int = 0
    
    // MARK: - Assignments
    @Published var assignments: [Assignment] = []
    @Published var pendingAssignmentCount: Int = 0
    
    // MARK: - Courses
    @Published var courses: [Course] = []
    
    // MARK: - Clubs
    @Published var clubs: [Club] = []
    
    // MARK: - Calendar Events
    @Published var calendarEvents: [CalendarEventModel] = []
    
    // MARK: - Rewards
    @Published var availableRewards: [Reward] = Reward.sampleRewards
    
    // MARK: - Today Stats
    @Published var todayStats: TodayStats = TodayStats()
    
    // MARK: - Initialization
    init() {
        loadSampleData()
        calculateStats()
    }
    
    // MARK: - Sample Data Loading
    private func loadSampleData() {
        // Load courses
        courses = [
            Course(name: "Human-Computer Interaction", code: "CSC 3104", lecturerName: "Prof. Emmet", room: "Room 301", colorHex: "9B59B6", icon: "laptopcomputer"),
            Course(name: "Web Development", code: "CSC 2201", lecturerName: "Dr. Parker", room: "Computer Lab A", colorHex: "E67E22", icon: "globe"),
            Course(name: "Database Systems", code: "CSC 2105", lecturerName: "Dr. Smith", room: "Room 205", colorHex: "27AE60", icon: "cylinder.split.1x2"),
            Course(name: "Software Engineering", code: "CSC 3201", lecturerName: "Prof. Johnson", room: "Room 401", colorHex: "3498DB", icon: "gearshape.2"),
            Course(name: "Mobile App Development", code: "CSC 3105", lecturerName: "Dr. Lee", room: "Lab B", colorHex: "E74C3C", icon: "iphone")
        ]
        
        // Load clubs
        clubs = [
            Club(name: "Tech Club", description: "For tech enthusiasts", category: .technology, colorHex: "3498DB"),
            Club(name: "Photography Society", description: "Capture moments", category: .arts, colorHex: "9B59B6"),
            Club(name: "Debate Club", description: "Voice your opinions", category: .academic, colorHex: "E74C3C")
        ]
        
        // Load assignments
        assignments = [
            Assignment(title: "AR App Final Project", description: "Create an AR application using ARKit", courseName: "Human-Computer Interaction", courseCode: "CSC 3104", lecturerName: "Prof. Emmet", dueDate: Date().addingTimeInterval(3 * 24 * 3600), status: .inProgress, priority: .high),
            Assignment(title: "JavaScript Lab 4", description: "Complete JavaScript DOM manipulation exercises", courseName: "Web Development", courseCode: "CSC 2201", lecturerName: "Dr. Parker", dueDate: Date().addingTimeInterval(1 * 24 * 3600), status: .inProgress, priority: .urgent),
            Assignment(title: "Database ER Diagram", description: "Design ER diagram for library system", courseName: "Database Systems", courseCode: "CSC 2105", lecturerName: "Dr. Smith", dueDate: Date().addingTimeInterval(5 * 24 * 3600), status: .pending, priority: .medium),
            Assignment(title: "UI/UX Case Study", description: "Analyze and document UI/UX of 3 apps", courseName: "Human-Computer Interaction", courseCode: "CSC 3104", lecturerName: "Prof. Emmet", dueDate: Date().addingTimeInterval(7 * 24 * 3600), status: .pending, priority: .low),
            Assignment(title: "Software Requirements Doc", description: "Write SRS document for project", courseName: "Software Engineering", courseCode: "CSC 3201", lecturerName: "Prof. Johnson", dueDate: Date().addingTimeInterval(-1 * 24 * 3600), status: .submitted, priority: .high, submittedAt: Date().addingTimeInterval(-2 * 24 * 3600)),
            Assignment(title: "Mobile App Wireframes", description: "Design wireframes for mobile app", courseName: "Mobile App Development", courseCode: "CSC 3105", lecturerName: "Dr. Lee", dueDate: Date().addingTimeInterval(-3 * 24 * 3600), status: .graded, priority: .medium, grade: 92, feedback: "Excellent work!")
        ]
        
        // Load announcements
        announcements = [
            Announcement(title: "Exam Venue Changed", content: "Tomorrow's Database Systems exam has been moved from Hall A to Hall B. Please arrive 15 minutes early.", category: .exam, priority: .urgent, authorName: "Dr. Smith", authorRole: .lecturer, createdAt: Date().addingTimeInterval(-1800)),
            Announcement(title: "New Assignment Posted", content: "AR App Final Project has been posted. Please check the requirements carefully. Due date: December 22, 2025.", category: .assignment, priority: .high, authorName: "Prof. Emmet", authorRole: .lecturer, createdAt: Date().addingTimeInterval(-3600)),
            Announcement(title: "Lab Session Rescheduled", content: "Friday's Mobile Dev lab has been moved to Monday 3 PM due to equipment maintenance.", category: .classReplacement, priority: .high, authorName: "Dr. Lee", authorRole: .lecturer, createdAt: Date().addingTimeInterval(-7200)),
            Announcement(title: "New Chapter Notes", content: "Chapter 5: Advanced JavaScript Functions notes are now available. Please download and study before the next class.", category: .newRevision, priority: .normal, authorName: "Dr. Parker", authorRole: .lecturer, attachments: [Attachment(name: "Chapter5_Notes.pdf", type: .pdf, size: 2048000)], createdAt: Date().addingTimeInterval(-28800)),
            Announcement(title: "Tech Club Meeting", content: "Weekly Tech Club meeting this Friday at 4 PM in Room 301. Topic: Introduction to AI.", category: .clubActivity, priority: .normal, authorName: "Tech Club Committee", authorRole: .clubCommittee, createdAt: Date().addingTimeInterval(-43200)),
            Announcement(title: "Semester Break Schedule", content: "The semester break will begin on December 23, 2025. Classes resume on January 6, 2026.", category: .officialNotice, priority: .normal, authorName: "Academic Office", authorRole: .admin, createdAt: Date().addingTimeInterval(-86400), isPinned: true)
        ]
        
        // Load calendar events
        let calendar = Calendar.current
        let today = Date()
        
        calendarEvents = [
            // Today's events
            CalendarEventModel(title: "HCI Lecture", date: today, startTime: calendar.date(bySettingHour: 10, minute: 0, second: 0, of: today)!, endTime: calendar.date(bySettingHour: 12, minute: 0, second: 0, of: today)!, location: "Room 301", type: .lecture, colorHex: "9B59B6"),
            CalendarEventModel(title: "Web Dev Lab", date: today, startTime: calendar.date(bySettingHour: 14, minute: 0, second: 0, of: today)!, endTime: calendar.date(bySettingHour: 16, minute: 0, second: 0, of: today)!, location: "Computer Lab A", type: .lab, colorHex: "E67E22"),
            
            // Tomorrow
            CalendarEventModel(title: "Database Quiz", date: calendar.date(byAdding: .day, value: 1, to: today)!, startTime: calendar.date(bySettingHour: 9, minute: 0, second: 0, of: calendar.date(byAdding: .day, value: 1, to: today)!)!, endTime: calendar.date(bySettingHour: 10, minute: 0, second: 0, of: calendar.date(byAdding: .day, value: 1, to: today)!)!, location: "Hall B", type: .exam, colorHex: "E74C3C"),
            
            // This week
            CalendarEventModel(title: "JavaScript Assignment Due", date: calendar.date(byAdding: .day, value: 1, to: today)!, startTime: calendar.date(bySettingHour: 23, minute: 59, second: 0, of: calendar.date(byAdding: .day, value: 1, to: today)!)!, endTime: calendar.date(bySettingHour: 23, minute: 59, second: 0, of: calendar.date(byAdding: .day, value: 1, to: today)!)!, location: "Online", type: .assignment, colorHex: "3498DB"),
            CalendarEventModel(title: "Tech Club Meeting", date: calendar.date(byAdding: .day, value: 2, to: today)!, startTime: calendar.date(bySettingHour: 16, minute: 0, second: 0, of: calendar.date(byAdding: .day, value: 2, to: today)!)!, endTime: calendar.date(bySettingHour: 17, minute: 30, second: 0, of: calendar.date(byAdding: .day, value: 2, to: today)!)!, location: "Room 301", type: .clubEvent, colorHex: "1ABC9C"),
            CalendarEventModel(title: "AR Project Due", date: calendar.date(byAdding: .day, value: 3, to: today)!, startTime: calendar.date(bySettingHour: 23, minute: 59, second: 0, of: calendar.date(byAdding: .day, value: 3, to: today)!)!, endTime: calendar.date(bySettingHour: 23, minute: 59, second: 0, of: calendar.date(byAdding: .day, value: 3, to: today)!)!, location: "Online", type: .assignment, colorHex: "9B59B6"),
            
            // Next week
            CalendarEventModel(title: "Database Final Exam", date: calendar.date(byAdding: .day, value: 5, to: today)!, startTime: calendar.date(bySettingHour: 9, minute: 0, second: 0, of: calendar.date(byAdding: .day, value: 5, to: today)!)!, endTime: calendar.date(bySettingHour: 11, minute: 0, second: 0, of: calendar.date(byAdding: .day, value: 5, to: today)!)!, location: "Hall A", type: .exam, colorHex: "E74C3C"),
            CalendarEventModel(title: "HCI Final Exam", date: calendar.date(byAdding: .day, value: 7, to: today)!, startTime: calendar.date(bySettingHour: 14, minute: 0, second: 0, of: calendar.date(byAdding: .day, value: 7, to: today)!)!, endTime: calendar.date(bySettingHour: 16, minute: 0, second: 0, of: calendar.date(byAdding: .day, value: 7, to: today)!)!, location: "Hall B", type: .exam, colorHex: "9B59B6")
        ]
    }
    
    // MARK: - Calculate Stats
    private func calculateStats() {
        unreadAnnouncementCount = announcements.filter { !$0.viewedBy.contains(currentUser.id) }.count
        pendingAssignmentCount = assignments.filter { $0.status == .pending || $0.status == .inProgress }.count
        
        todayStats = TodayStats(
            unreadAnnouncements: unreadAnnouncementCount,
            pendingAssignments: pendingAssignmentCount,
            upcomingExams: calendarEvents.filter { $0.type == .exam && $0.date > Date() }.count,
            todayEvents: calendarEvents.filter { Calendar.current.isDateInToday($0.date) }.count,
            currentStreak: currentUser.currentStreak,
            points: currentUser.points
        )
    }
    
    // MARK: - Actions
    
    func markAnnouncementAsRead(_ announcement: Announcement) {
        if let index = announcements.firstIndex(where: { $0.id == announcement.id }) {
            if !announcements[index].viewedBy.contains(currentUser.id) {
                announcements[index].viewedBy.append(currentUser.id)
                addPoints(5, reason: "Viewed announcement")
            }
        }
        calculateStats()
    }
    
    func acknowledgeAnnouncement(_ announcement: Announcement) {
        if let index = announcements.firstIndex(where: { $0.id == announcement.id }) {
            if !announcements[index].acknowledgedBy.contains(currentUser.id) {
                announcements[index].acknowledgedBy.append(currentUser.id)
                addPoints(10, reason: "Acknowledged announcement")
            }
        }
    }
    
    func updateAssignmentStatus(_ assignment: Assignment, status: AssignmentStatus) {
        if let index = assignments.firstIndex(where: { $0.id == assignment.id }) {
            assignments[index].status = status
            if status == .submitted {
                assignments[index].submittedAt = Date()
                if !assignment.isOverdue {
                    addPoints(20, reason: "Submitted assignment on time")
                }
            }
        }
        calculateStats()
    }
    
    func addPoints(_ points: Int, reason: String) {
        currentUser.points += points
        // Could add notification here
    }
    
    func incrementStreak() {
        currentUser.currentStreak += 1
        if currentUser.currentStreak > currentUser.longestStreak {
            currentUser.longestStreak = currentUser.currentStreak
        }
        
        // Bonus points for streak milestones
        if currentUser.currentStreak == 7 {
            addPoints(50, reason: "7-day streak!")
        } else if currentUser.currentStreak == 30 {
            addPoints(200, reason: "30-day streak!")
        }
    }
    
    func redeemReward(_ reward: Reward) -> Bool {
        guard currentUser.points >= reward.pointsCost else { return false }
        currentUser.points -= reward.pointsCost
        calculateStats()
        return true
    }
    
    // MARK: - Reset Points (For Testing)
    func resetPoints() {
        currentUser.points = 500
        calculateStats()
    }
    
    func rsvpToEvent(_ event: ClubEvent, clubId: UUID) {
        if let clubIndex = clubs.firstIndex(where: { $0.id == clubId }),
           let eventIndex = clubs[clubIndex].events.firstIndex(where: { $0.id == event.id }) {
            if !clubs[clubIndex].events[eventIndex].rsvpList.contains(currentUser.id) {
                clubs[clubIndex].events[eventIndex].rsvpList.append(currentUser.id)
                addPoints(15, reason: "RSVP'd to event")
            }
        }
    }
}

// MARK: - Today Stats
struct TodayStats {
    var unreadAnnouncements: Int = 0
    var pendingAssignments: Int = 0
    var upcomingExams: Int = 0
    var todayEvents: Int = 0
    var currentStreak: Int = 0
    var points: Int = 0
}
