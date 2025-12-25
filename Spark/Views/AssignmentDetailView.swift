//
//  AssignmentDetailView.swift
//  Spark
//
//  Detailed assignment view with submission functionality
//

import SwiftUI

// MARK: - Assignment Detail View
struct AssignmentDetailView: View {
    
    let assignment: Assignment
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme
    @State private var showSubmitSheet = false
    
    private var daysUntilDueText: String {
        let days = assignment.daysUntilDue
        if days < 0 {
            return "\(abs(days)) days overdue"
        } else if days == 0 {
            return "Due today"
        } else if days == 1 {
            return "Due tomorrow"
        } else {
            return "Due in \(days) days"
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
                                Label("Add to Calendar", systemImage: "calendar.badge.plus")
                            }
                            Button(action: {}) {
                                Label("Set Reminder", systemImage: "bell.badge")
                            }
                            Button(action: {}) {
                                Label("Share", systemImage: "square.and.arrow.up")
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
                    
                    // Status & Priority Badge
                    VStack(spacing: 16) {
                        ZStack {
                            Circle()
                                .fill(assignment.status.color.opacity(0.15))
                                .frame(width: 80, height: 80)
                            
                            Image(systemName: assignment.status.icon)
                                .font(.system(size: 36))
                                .foregroundStyle(assignment.status.color)
                        }
                        .shadow(color: assignment.status.color.opacity(0.3), radius: 12, x: 0, y: 6)
                        
                        HStack(spacing: 8) {
                            Text(assignment.status.rawValue)
                                .font(.system(size: 13, weight: .bold))
                                .foregroundStyle(assignment.status.color)
                                .padding(.horizontal, 14)
                                .padding(.vertical, 6)
                                .background(
                                    Capsule()
                                        .fill(assignment.status.color.opacity(0.12))
                                )
                            
                            Text(assignment.priority.rawValue)
                                .font(.system(size: 13, weight: .bold))
                                .foregroundStyle(assignment.priority.color)
                                .padding(.horizontal, 14)
                                .padding(.vertical, 6)
                                .background(
                                    Capsule()
                                        .fill(assignment.priority.color.opacity(0.12))
                                )
                        }
                    }
                    
                    // Main Content Card
                    VStack(alignment: .leading, spacing: 20) {
                        // Title
                        Text(assignment.title)
                            .font(.system(size: 24, weight: .bold))
                            .foregroundStyle(colorScheme == .dark ? .white : .primary)
                        
                        // Course & Lecturer Info
                        HStack(spacing: 16) {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Course")
                                    .font(.system(size: 11, weight: .medium))
                                    .foregroundStyle(.secondary)
                                Text(assignment.courseCode)
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundStyle(colorScheme == .dark ? .white : .primary)
                            }
                            
                            Divider()
                                .frame(height: 30)
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Lecturer")
                                    .font(.system(size: 11, weight: .medium))
                                    .foregroundStyle(.secondary)
                                Text(assignment.lecturerName)
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundStyle(colorScheme == .dark ? .white : .primary)
                            }
                        }
                        
                        Divider()
                            .background(colorScheme == .dark ? Color.white.opacity(0.1) : Color.gray.opacity(0.3))
                        
                        // Due Date Section
                        HStack(spacing: 12) {
                            Image(systemName: "clock.fill")
                                .font(.system(size: 20))
                                .foregroundStyle(assignment.dueDateCategory.color)
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Due Date")
                                    .font(.system(size: 11, weight: .medium))
                                    .foregroundStyle(.secondary)
                                
                                Text(assignment.dueDate.formatted(date: .complete, time: .shortened))
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundStyle(colorScheme == .dark ? .white : .primary)
                            }
                            
                            Spacer()
                            
                            Text(daysUntilDueText)
                                .font(.system(size: 12, weight: .bold))
                                .foregroundStyle(assignment.dueDateCategory.color)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 6)
                                .background(
                                    Capsule()
                                        .fill(assignment.dueDateCategory.color.opacity(0.12))
                                )
                        }
                        
                        Divider()
                            .background(colorScheme == .dark ? Color.white.opacity(0.1) : Color.gray.opacity(0.3))
                        
                        // Description
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Description")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundStyle(colorScheme == .dark ? .white : .primary)
                            
                            Text(assignment.description.isEmpty ? "No description provided." : assignment.description)
                                .font(.system(size: 15))
                                .foregroundStyle(colorScheme == .dark ? .white.opacity(0.85) : .primary.opacity(0.85))
                                .lineSpacing(4)
                        }
                        
                        // Attached Files
                        if !assignment.attachments.isEmpty {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Attached Files")
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundStyle(colorScheme == .dark ? .white : .primary)
                                
                                ForEach(assignment.attachments) { attachment in
                                    AttachmentRow(attachment: attachment)
                                }
                            }
                        }
                        
                        // Grade Section (if graded)
                        if let grade = assignment.grade {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Grade")
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundStyle(colorScheme == .dark ? .white : .primary)
                                
                                HStack {
                                    Text("\(Int(grade))")
                                        .font(.system(size: 36, weight: .bold, design: .rounded))
                                        .foregroundStyle(.green)
                                    
                                    Text("/ \(Int(assignment.maxGrade))")
                                        .font(.system(size: 20, weight: .medium))
                                        .foregroundStyle(.secondary)
                                    
                                    Spacer()
                                    
                                    let percentage = (grade / assignment.maxGrade) * 100
                                    Text("\(Int(percentage))%")
                                        .font(.system(size: 24, weight: .bold))
                                        .foregroundStyle(.green)
                                }
                                
                                if let feedback = assignment.feedback {
                                    VStack(alignment: .leading, spacing: 8) {
                                        Text("Feedback")
                                            .font(.system(size: 14, weight: .semibold))
                                            .foregroundStyle(colorScheme == .dark ? .white : .primary)
                                        
                                        Text(feedback)
                                            .font(.system(size: 14))
                                            .foregroundStyle(.secondary)
                                            .padding(12)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .background(
                                                RoundedRectangle(cornerRadius: 12)
                                                    .fill(colorScheme == .dark ? Color.white.opacity(0.06) : Color.gray.opacity(0.08))
                                            )
                                    }
                                }
                            }
                            .padding(16)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color.green.opacity(0.08))
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
                    
                    // Submit Button (if not submitted/graded)
                    if assignment.status != .submitted && assignment.status != .graded {
                        Button(action: { showSubmitSheet = true }) {
                            HStack(spacing: 12) {
                                Image(systemName: "paperplane.fill")
                                    .font(.system(size: 18))
                                
                                Text("Submit Work")
                                    .font(.system(size: 17, weight: .semibold))
                            }
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(
                                        LinearGradient(
                                            colors: [.blue, .blue.opacity(0.8)],
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                                    .shadow(color: .blue.opacity(0.4), radius: 12, x: 0, y: 6)
                            )
                        }
                        .padding(.horizontal, 20)
                    }
                    
                    // Bottom spacing
                    Color.clear.frame(height: 40)
                }
            }
        }
        .navigationBarHidden(true)
        .sheet(isPresented: $showSubmitSheet) {
            SubmitWorkSheet(assignment: assignment)
        }
    }
}

// MARK: - Attachment Row
struct AttachmentRow: View {
    let attachment: Attachment
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: attachment.type.icon)
                .font(.system(size: 20))
                .foregroundStyle(attachment.type.color)
                .frame(width: 44, height: 44)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(attachment.type.color.opacity(0.12))
                )
            
            VStack(alignment: .leading, spacing: 4) {
                Text(attachment.name)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(colorScheme == .dark ? .white : .primary)
                    .lineLimit(1)
                
                Text(attachment.sizeString)
                    .font(.system(size: 12))
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            Button(action: {}) {
                Image(systemName: "arrow.down.circle.fill")
                    .font(.system(size: 24))
                    .foregroundStyle(.blue)
            }
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(colorScheme == .dark ? Color.white.opacity(0.06) : Color.gray.opacity(0.08))
        )
    }
}

// MARK: - Submit Work Sheet
struct SubmitWorkSheet: View {
    let assignment: Assignment
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme
    @State private var submissionText = ""
    
    var body: some View {
        NavigationStack {
            ZStack {
                SparkBackground()
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Title
                        VStack(spacing: 8) {
                            Text("Submit Assignment")
                                .font(.system(size: 24, weight: .bold))
                                .foregroundStyle(colorScheme == .dark ? .white : .primary)
                            
                            Text(assignment.title)
                                .font(.system(size: 14))
                                .foregroundStyle(.secondary)
                        }
                        .padding(.top, 20)
                        
                        // Upload Area
                        VStack(spacing: 16) {
                            Button(action: {}) {
                                VStack(spacing: 12) {
                                    Image(systemName: "arrow.up.doc.fill")
                                        .font(.system(size: 40))
                                        .foregroundStyle(.blue)
                                    
                                    Text("Upload Files")
                                        .font(.system(size: 16, weight: .semibold))
                                        .foregroundStyle(.blue)
                                    
                                    Text("PDF, DOC, ZIP up to 50MB")
                                        .font(.system(size: 12))
                                        .foregroundStyle(.secondary)
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 40)
                                .background(
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(style: StrokeStyle(lineWidth: 2, dash: [8]))
                                        .foregroundStyle(.blue.opacity(0.3))
                                )
                            }
                            
                            // Notes
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Add Notes (Optional)")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundStyle(colorScheme == .dark ? .white : .primary)
                                
                                TextEditor(text: $submissionText)
                                    .font(.system(size: 14))
                                    .frame(height: 120)
                                    .padding(12)
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(colorScheme == .dark ? Color.white.opacity(0.08) : Color.gray.opacity(0.1))
                                    )
                            }
                        }
                        .padding(20)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(.ultraThinMaterial)
                        )
                        
                        // Submit Button
                        Button(action: { dismiss() }) {
                            Text("Submit Now")
                                .font(.system(size: 17, weight: .semibold))
                                .foregroundStyle(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(LinearGradient(colors: [.blue, .blue.opacity(0.8)], startPoint: .leading, endPoint: .trailing))
                                        .shadow(color: .blue.opacity(0.4), radius: 12, x: 0, y: 6)
                                )
                        }
                    }
                    .padding(.horizontal, 20)
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                        .foregroundStyle(.blue)
                }
            }
        }
    }
}

// MARK: - Preview
#Preview {
    NavigationStack {
        AssignmentDetailView(
            assignment: Assignment(
                title: "AR App Final Project",
                description: "Develop a fully functional augmented reality mobile application using ARKit or ARCore. The app should demonstrate practical use cases and include proper documentation.",
                courseId: UUID(),
                courseName: "Human-Computer Interaction",
                courseCode: "HCI-301",
                lecturerName: "Prof. Emmet",
                dueDate: Date().addingTimeInterval(86400 * 5),
                status: .pending,
                priority: .high,
                attachments: [
                    Attachment(name: "Project Brief.pdf", type: .pdf, size: 2048000),
                    Attachment(name: "Design Guidelines.pdf", type: .pdf, size: 1536000)
                ],
                maxGrade: 100
            )
        )
    }
}
