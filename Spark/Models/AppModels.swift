//
//  AppModels.swift
//  Spark
//
//  Core data models for the Spark student notification system
//

import SwiftUI

// MARK: - User Models

struct SparkUser: Identifiable, Codable {
    let id: UUID
    var name: String
    var email: String
    var studentId: String?
    var role: SparkUserRole
    var program: String
    var year: Int
    var semester: Int
    var department: String
    var phone: String
    var clubs: [String]
    var credits: Int
    var attendance: Int
    var bio: String
    var profileImageURL: String?
    var enrolledCourses: [UUID]
    var joinedClubs: [UUID]
    var points: Int
    var currentStreak: Int
    var longestStreak: Int
    var badges: [Badge]
    var notificationPreferences: NotificationPreferences
    var createdAt: Date
    var lastActiveAt: Date
    
    init(
        id: UUID = UUID(),
        name: String,
        email: String,
        studentId: String? = nil,
        role: SparkUserRole = .student,
        program: String = "",
        year: Int = 1,
        semester: Int = 1,
        department: String = "",
        phone: String = "",
        clubs: [String] = [],
        credits: Int = 0,
        attendance: Int = 0,
        bio: String = "",
        profileImageURL: String? = nil,
        enrolledCourses: [UUID] = [],
        joinedClubs: [UUID] = [],
        points: Int = 0,
        currentStreak: Int = 0,
        longestStreak: Int = 0,
        badges: [Badge] = [],
        notificationPreferences: NotificationPreferences = NotificationPreferences(),
        createdAt: Date = Date(),
        lastActiveAt: Date = Date()
    ) {
        self.id = id
        self.name = name
        self.email = email
        self.studentId = studentId
        self.role = role
        self.program = program
        self.year = year
        self.semester = semester
        self.department = department
        self.phone = phone
        self.clubs = clubs
        self.credits = credits
        self.attendance = attendance
        self.bio = bio
        self.profileImageURL = profileImageURL
        self.enrolledCourses = enrolledCourses
        self.joinedClubs = joinedClubs
        self.points = points
        self.currentStreak = currentStreak
        self.longestStreak = longestStreak
        self.badges = badges
        self.notificationPreferences = notificationPreferences
        self.createdAt = createdAt
        self.lastActiveAt = lastActiveAt
    }
    
    var initials: String {
        let components = name.components(separatedBy: " ")
        return components.prefix(2).compactMap { $0.first }.map { String($0) }.joined().uppercased()
    }
    
    static let sampleStudent = SparkUser(
        name: "John Skibidi",
        email: "m-15005933@moe-edu.my",
        studentId: "CS2025-1842",
        role: .student,
        program: "Computer Science",
        year: 2,
        semester: 1,
        department: "Computer Science",
        phone: "012-3290425",
        clubs: ["Tech Club", "Gaming Society"],
        credits: 45,
        attendance: 92,
        bio: "I might fail my class but at least I got a degree",
        points: 563,
        currentStreak: 7,
        longestStreak: 14,
        badges: Badge.sampleBadges
    )
}

enum SparkUserRole: String, Codable, CaseIterable {
    case student = "Student"
    case lecturer = "Lecturer"
    case clubCommittee = "Club Committee"
    case admin = "Admin"
    
    var color: Color {
        switch self {
        case .student: return .blue
        case .lecturer: return .green
        case .clubCommittee: return .purple
        case .admin: return .red
        }
    }
}

struct NotificationPreferences: Codable {
    var pushEnabled: Bool = true
    var emailEnabled: Bool = false
    var urgentOnly: Bool = false
    var assignmentReminders: Bool = true
    var examReminders: Bool = true
    var clubUpdates: Bool = true
    var deadlineAlerts: Bool = true
    var streakReminders: Bool = true
}

// MARK: - Announcement Models

struct Announcement: Identifiable, Codable {
    let id: UUID
    var title: String
    var content: String
    var category: AnnouncementCategory
    var priority: AnnouncementPriority
    var courseId: UUID?
    var clubId: UUID?
    var authorId: UUID
    var authorName: String
    var authorRole: SparkUserRole
    var attachments: [Attachment]
    var version: Int
    var changelog: [ChangelogEntry]
    var viewedBy: [UUID]
    var acknowledgedBy: [UUID]
    var createdAt: Date
    var updatedAt: Date
    var expiresAt: Date?
    var isPinned: Bool
    
    init(
        id: UUID = UUID(),
        title: String,
        content: String,
        category: AnnouncementCategory,
        priority: AnnouncementPriority = .normal,
        courseId: UUID? = nil,
        clubId: UUID? = nil,
        authorId: UUID = UUID(),
        authorName: String,
        authorRole: SparkUserRole = .lecturer,
        attachments: [Attachment] = [],
        version: Int = 1,
        changelog: [ChangelogEntry] = [],
        viewedBy: [UUID] = [],
        acknowledgedBy: [UUID] = [],
        createdAt: Date = Date(),
        updatedAt: Date = Date(),
        expiresAt: Date? = nil,
        isPinned: Bool = false
    ) {
        self.id = id
        self.title = title
        self.content = content
        self.category = category
        self.priority = priority
        self.courseId = courseId
        self.clubId = clubId
        self.authorId = authorId
        self.authorName = authorName
        self.authorRole = authorRole
        self.attachments = attachments
        self.version = version
        self.changelog = changelog
        self.viewedBy = viewedBy
        self.acknowledgedBy = acknowledgedBy
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.expiresAt = expiresAt
        self.isPinned = isPinned
    }
    
    var isUpdated: Bool { version > 1 }
    var viewCount: Int { viewedBy.count }
    var acknowledgeCount: Int { acknowledgedBy.count }
}

enum AnnouncementCategory: String, Codable, CaseIterable {
    case assignment = "Assignment"
    case deadline = "Deadline"
    case exam = "Exam"
    case classCancellation = "Class Cancellation"
    case classReplacement = "Class Replacement"
    case newRevision = "New Revision"
    case clubActivity = "Club Activity"
    case officialNotice = "Official Notice"
    case general = "General"
    
    var icon: String {
        switch self {
        case .assignment: return "doc.text.fill"
        case .deadline: return "clock.fill"
        case .exam: return "pencil.and.ruler.fill"
        case .classCancellation: return "xmark.circle.fill"
        case .classReplacement: return "arrow.triangle.2.circlepath"
        case .newRevision: return "doc.badge.plus"
        case .clubActivity: return "person.3.fill"
        case .officialNotice: return "megaphone.fill"
        case .general: return "info.circle.fill"
        }
    }
    
    var color: Color {
        switch self {
        case .assignment: return .blue
        case .deadline: return .orange
        case .exam: return .red
        case .classCancellation: return .red
        case .classReplacement: return .purple
        case .newRevision: return .green
        case .clubActivity: return .cyan
        case .officialNotice: return .indigo
        case .general: return .gray
        }
    }
}

enum AnnouncementPriority: String, Codable, CaseIterable {
    case urgent = "Urgent"
    case high = "High"
    case normal = "Normal"
    case low = "Low"
    
    var color: Color {
        switch self {
        case .urgent: return .red
        case .high: return .orange
        case .normal: return .blue
        case .low: return .gray
        }
    }
    
    var sortValue: Int {
        switch self {
        case .urgent: return 0
        case .high: return 1
        case .normal: return 2
        case .low: return 3
        }
    }
}

struct Attachment: Identifiable, Codable {
    let id: UUID
    var name: String
    var type: AttachmentType
    var url: String
    var size: Int64
    var version: Int
    var uploadedAt: Date
    
    init(id: UUID = UUID(), name: String, type: AttachmentType, url: String = "", size: Int64 = 0, version: Int = 1, uploadedAt: Date = Date()) {
        self.id = id
        self.name = name
        self.type = type
        self.url = url
        self.size = size
        self.version = version
        self.uploadedAt = uploadedAt
    }
    
    var sizeString: String {
        let formatter = ByteCountFormatter()
        formatter.countStyle = .file
        return formatter.string(fromByteCount: size)
    }
}

enum AttachmentType: String, Codable {
    case pdf, doc, ppt, image, video, link, other
    
    var icon: String {
        switch self {
        case .pdf: return "doc.fill"
        case .doc: return "doc.text.fill"
        case .ppt: return "slider.horizontal.below.rectangle"
        case .image: return "photo.fill"
        case .video: return "video.fill"
        case .link: return "link"
        case .other: return "paperclip"
        }
    }
    
    var color: Color {
        switch self {
        case .pdf: return .red
        case .doc: return .blue
        case .ppt: return .orange
        case .image: return .green
        case .video: return .purple
        case .link: return .cyan
        case .other: return .gray
        }
    }
}

struct ChangelogEntry: Identifiable, Codable {
    let id: UUID
    var version: Int
    var changes: String
    var changedAt: Date
    var changedBy: String
    
    init(id: UUID = UUID(), version: Int, changes: String, changedAt: Date = Date(), changedBy: String) {
        self.id = id
        self.version = version
        self.changes = changes
        self.changedAt = changedAt
        self.changedBy = changedBy
    }
}

// MARK: - Assignment Models

struct Assignment: Identifiable, Codable {
    let id: UUID
    var title: String
    var description: String
    var courseId: UUID
    var courseName: String
    var courseCode: String
    var lecturerName: String
    var dueDate: Date
    var status: AssignmentStatus
    var priority: AssignmentPriority
    var attachments: [Attachment]
    var submittedAt: Date?
    var grade: Double?
    var maxGrade: Double
    var feedback: String?
    var version: Int
    var createdAt: Date
    var updatedAt: Date
    
    init(
        id: UUID = UUID(),
        title: String,
        description: String = "",
        courseId: UUID = UUID(),
        courseName: String,
        courseCode: String,
        lecturerName: String,
        dueDate: Date,
        status: AssignmentStatus = .pending,
        priority: AssignmentPriority = .medium,
        attachments: [Attachment] = [],
        submittedAt: Date? = nil,
        grade: Double? = nil,
        maxGrade: Double = 100,
        feedback: String? = nil,
        version: Int = 1,
        createdAt: Date = Date(),
        updatedAt: Date = Date()
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.courseId = courseId
        self.courseName = courseName
        self.courseCode = courseCode
        self.lecturerName = lecturerName
        self.dueDate = dueDate
        self.status = status
        self.priority = priority
        self.attachments = attachments
        self.submittedAt = submittedAt
        self.grade = grade
        self.maxGrade = maxGrade
        self.feedback = feedback
        self.version = version
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
    
    var isOverdue: Bool {
        dueDate < Date() && status != .submitted && status != .graded
    }
    
    var daysUntilDue: Int {
        Calendar.current.dateComponents([.day], from: Calendar.current.startOfDay(for: Date()), to: Calendar.current.startOfDay(for: dueDate)).day ?? 0
    }
    
    var dueDateCategory: DueDateCategory {
        let days = daysUntilDue
        if days < 0 { return .overdue }
        if days == 0 { return .today }
        if days <= 2 { return .dueSoon }
        if days <= 7 { return .thisWeek }
        if days <= 14 { return .nextWeek }
        return .later
    }
}

enum AssignmentStatus: String, Codable, CaseIterable {
    case pending = "Pending"
    case inProgress = "In Progress"
    case submitted = "Submitted"
    case graded = "Graded"
    case late = "Late"
    
    var color: Color {
        switch self {
        case .pending: return .gray
        case .inProgress: return .blue
        case .submitted: return .green
        case .graded: return .purple
        case .late: return .red
        }
    }
    
    var icon: String {
        switch self {
        case .pending: return "circle"
        case .inProgress: return "circle.lefthalf.filled"
        case .submitted: return "checkmark.circle.fill"
        case .graded: return "star.circle.fill"
        case .late: return "exclamationmark.circle.fill"
        }
    }
}

enum AssignmentPriority: String, Codable, CaseIterable {
    case low = "Low"
    case medium = "Medium"
    case high = "High"
    case urgent = "Urgent"
    
    var color: Color {
        switch self {
        case .low: return .green
        case .medium: return .yellow
        case .high: return .orange
        case .urgent: return .red
        }
    }
}

enum DueDateCategory: String {
    case overdue = "Overdue"
    case today = "Today"
    case dueSoon = "Due Soon"
    case thisWeek = "This Week"
    case nextWeek = "Next Week"
    case later = "Later"
    
    var color: Color {
        switch self {
        case .overdue: return .red
        case .today: return .orange
        case .dueSoon: return .yellow
        case .thisWeek: return .blue
        case .nextWeek: return .purple
        case .later: return .gray
        }
    }
}

// MARK: - Course Models

struct Course: Identifiable, Codable {
    let id: UUID
    var name: String
    var code: String
    var description: String
    var lecturerId: UUID
    var lecturerName: String
    var schedule: [ClassSchedule]
    var room: String
    var colorHex: String
    var icon: String
    var semester: String
    var credits: Int
    var enrolledStudents: [UUID]
    
    init(
        id: UUID = UUID(),
        name: String,
        code: String,
        description: String = "",
        lecturerId: UUID = UUID(),
        lecturerName: String,
        schedule: [ClassSchedule] = [],
        room: String,
        colorHex: String = "4A90E2",
        icon: String = "book.fill",
        semester: String = "Fall 2025",
        credits: Int = 3,
        enrolledStudents: [UUID] = []
    ) {
        self.id = id
        self.name = name
        self.code = code
        self.description = description
        self.lecturerId = lecturerId
        self.lecturerName = lecturerName
        self.schedule = schedule
        self.room = room
        self.colorHex = colorHex
        self.icon = icon
        self.semester = semester
        self.credits = credits
        self.enrolledStudents = enrolledStudents
    }
    
    var color: Color { Color(hex: colorHex) }
}

struct ClassSchedule: Identifiable, Codable {
    let id: UUID
    var dayOfWeek: Int // 1 = Sunday, 7 = Saturday
    var startTime: Date
    var endTime: Date
    var room: String
    var type: ClassType
    
    init(id: UUID = UUID(), dayOfWeek: Int, startTime: Date, endTime: Date, room: String, type: ClassType = .lecture) {
        self.id = id
        self.dayOfWeek = dayOfWeek
        self.startTime = startTime
        self.endTime = endTime
        self.room = room
        self.type = type
    }
    
    var dayName: String {
        let days = ["", "Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
        return days[dayOfWeek]
    }
}

enum ClassType: String, Codable {
    case lecture = "Lecture"
    case lab = "Lab"
    case tutorial = "Tutorial"
    case seminar = "Seminar"
}

// MARK: - Club Models

struct Club: Identifiable, Codable {
    let id: UUID
    var name: String
    var description: String
    var category: ClubCategory
    var logoURL: String?
    var coverImageURL: String?
    var committeeMembers: [UUID]
    var members: [UUID]
    var events: [ClubEvent]
    var colorHex: String
    var isActive: Bool
    var createdAt: Date
    
    init(
        id: UUID = UUID(),
        name: String,
        description: String = "",
        category: ClubCategory = .academic,
        logoURL: String? = nil,
        coverImageURL: String? = nil,
        committeeMembers: [UUID] = [],
        members: [UUID] = [],
        events: [ClubEvent] = [],
        colorHex: String = "9B59B6",
        isActive: Bool = true,
        createdAt: Date = Date()
    ) {
        self.id = id
        self.name = name
        self.description = description
        self.category = category
        self.logoURL = logoURL
        self.coverImageURL = coverImageURL
        self.committeeMembers = committeeMembers
        self.members = members
        self.events = events
        self.colorHex = colorHex
        self.isActive = isActive
        self.createdAt = createdAt
    }
    
    var color: Color { Color(hex: colorHex) }
    var memberCount: Int { members.count }
}

enum ClubCategory: String, Codable, CaseIterable {
    case academic = "Academic"
    case sports = "Sports"
    case arts = "Arts & Culture"
    case technology = "Technology"
    case community = "Community Service"
    case other = "Other"
    
    var icon: String {
        switch self {
        case .academic: return "graduationcap.fill"
        case .sports: return "sportscourt.fill"
        case .arts: return "paintpalette.fill"
        case .technology: return "laptopcomputer"
        case .community: return "heart.fill"
        case .other: return "star.fill"
        }
    }
}

struct ClubEvent: Identifiable, Codable {
    let id: UUID
    var title: String
    var description: String
    var date: Date
    var endDate: Date?
    var location: String
    var posterURL: String?
    var maxParticipants: Int?
    var rsvpList: [UUID]
    var createdAt: Date
    
    init(
        id: UUID = UUID(),
        title: String,
        description: String = "",
        date: Date,
        endDate: Date? = nil,
        location: String,
        posterURL: String? = nil,
        maxParticipants: Int? = nil,
        rsvpList: [UUID] = [],
        createdAt: Date = Date()
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.date = date
        self.endDate = endDate
        self.location = location
        self.posterURL = posterURL
        self.maxParticipants = maxParticipants
        self.rsvpList = rsvpList
        self.createdAt = createdAt
    }
    
    var rsvpCount: Int { rsvpList.count }
    var spotsLeft: Int? {
        guard let max = maxParticipants else { return nil }
        return max - rsvpCount
    }
}

// MARK: - Reward System Models

struct Badge: Identifiable, Codable {
    let id: UUID
    var name: String
    var description: String
    var icon: String
    var colorHex: String
    var category: BadgeCategory
    var requirement: String
    var earnedAt: Date?
    var isEarned: Bool
    
    init(
        id: UUID = UUID(),
        name: String,
        description: String,
        icon: String,
        colorHex: String,
        category: BadgeCategory,
        requirement: String,
        earnedAt: Date? = nil,
        isEarned: Bool = false
    ) {
        self.id = id
        self.name = name
        self.description = description
        self.icon = icon
        self.colorHex = colorHex
        self.category = category
        self.requirement = requirement
        self.earnedAt = earnedAt
        self.isEarned = isEarned
    }
    
    var color: Color { Color(hex: colorHex) }
    
    static let sampleBadges: [Badge] = [
        Badge(name: "Early Bird", description: "Check updates within 1 hour of posting", icon: "sunrise.fill", colorHex: "F39C12", category: .engagement, requirement: "View 10 announcements within 1 hour", earnedAt: Date(), isEarned: true),
        Badge(name: "Streak Master", description: "Maintain a 7-day streak", icon: "flame.fill", colorHex: "E74C3C", category: .streak, requirement: "7 consecutive days", earnedAt: Date(), isEarned: true),
        Badge(name: "Organized Student", description: "Complete all assignments on time", icon: "checkmark.seal.fill", colorHex: "27AE60", category: .academic, requirement: "10 on-time submissions", isEarned: false),
        Badge(name: "Club Supporter", description: "RSVP to 5 club events", icon: "person.3.fill", colorHex: "9B59B6", category: .social, requirement: "5 event RSVPs", isEarned: false)
    ]
}

enum BadgeCategory: String, Codable, CaseIterable {
    case engagement = "Engagement"
    case streak = "Streak"
    case academic = "Academic"
    case social = "Social"
    case special = "Special"
}

struct Reward: Identifiable, Codable {
    let id: UUID
    var name: String
    var description: String
    var pointsCost: Int
    var category: RewardCategory
    var icon: String
    var colorHex: String
    var isAvailable: Bool
    var stock: Int?
    var expiresAt: Date?
    
    init(
        id: UUID = UUID(),
        name: String,
        description: String,
        pointsCost: Int,
        category: RewardCategory,
        icon: String,
        colorHex: String,
        isAvailable: Bool = true,
        stock: Int? = nil,
        expiresAt: Date? = nil
    ) {
        self.id = id
        self.name = name
        self.description = description
        self.pointsCost = pointsCost
        self.category = category
        self.icon = icon
        self.colorHex = colorHex
        self.isAvailable = isAvailable
        self.stock = stock
        self.expiresAt = expiresAt
    }
    
    var color: Color { Color(hex: colorHex) }
    
    static let sampleRewards: [Reward] = [
        Reward(name: "Printing Credits", description: "50 pages of free printing", pointsCost: 100, category: .utility, icon: "printer.fill", colorHex: "3498DB"),
        Reward(name: "Cafeteria Voucher", description: "RM5 off at campus cafeteria", pointsCost: 150, category: .food, icon: "cup.and.saucer.fill", colorHex: "E67E22"),
        Reward(name: "Stationery Pack", description: "Notebook + pens set", pointsCost: 200, category: .merchandise, icon: "pencil.and.outline", colorHex: "9B59B6"),
        Reward(name: "Club Event Ticket", description: "Free entry to any club event", pointsCost: 250, category: .events, icon: "ticket.fill", colorHex: "1ABC9C"),
        Reward(name: "GrabFood Voucher", description: "RM10 GrabFood voucher", pointsCost: 300, category: .food, icon: "bag.fill", colorHex: "27AE60"),
        Reward(name: "Premium Stickers", description: "Exclusive Spark sticker pack", pointsCost: 75, category: .merchandise, icon: "star.circle.fill", colorHex: "F1C40F")
    ]
}

enum RewardCategory: String, Codable, CaseIterable {
    case utility = "Utility"
    case food = "Food & Drinks"
    case merchandise = "Merchandise"
    case events = "Events"
    case digital = "Digital"
}

// MARK: - Calendar Event Model

struct CalendarEventModel: Identifiable, Codable {
    let id: UUID
    var title: String
    var description: String
    var date: Date
    var startTime: Date
    var endTime: Date
    var location: String
    var type: CalendarEventType
    var colorHex: String
    var courseId: UUID?
    var clubId: UUID?
    var assignmentId: UUID?
    var isAllDay: Bool
    var reminder: Date?
    
    init(
        id: UUID = UUID(),
        title: String,
        description: String = "",
        date: Date,
        startTime: Date,
        endTime: Date,
        location: String = "",
        type: CalendarEventType,
        colorHex: String = "4A90E2",
        courseId: UUID? = nil,
        clubId: UUID? = nil,
        assignmentId: UUID? = nil,
        isAllDay: Bool = false,
        reminder: Date? = nil
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.date = date
        self.startTime = startTime
        self.endTime = endTime
        self.location = location
        self.type = type
        self.colorHex = colorHex
        self.courseId = courseId
        self.clubId = clubId
        self.assignmentId = assignmentId
        self.isAllDay = isAllDay
        self.reminder = reminder
    }
    
    var color: Color { Color(hex: colorHex) }
}

enum CalendarEventType: String, Codable, CaseIterable {
    case lecture = "Lecture"
    case lab = "Lab"
    case assignment = "Assignment"
    case exam = "Exam"
    case meeting = "Meeting"
    case clubEvent = "Club Event"
    case personal = "Personal"
    case holiday = "Holiday"
    
    var icon: String {
        switch self {
        case .lecture: return "book.fill"
        case .lab: return "laptopcomputer"
        case .assignment: return "doc.text.fill"
        case .exam: return "pencil.and.ruler.fill"
        case .meeting: return "person.3.fill"
        case .clubEvent: return "flag.fill"
        case .personal: return "person.fill"
        case .holiday: return "gift.fill"
        }
    }
    
    var defaultColor: Color {
        switch self {
        case .lecture: return .purple
        case .lab: return .orange
        case .assignment: return .blue
        case .exam: return .red
        case .meeting: return .green
        case .clubEvent: return .cyan
        case .personal: return .gray
        case .holiday: return .pink
        }
    }
}
