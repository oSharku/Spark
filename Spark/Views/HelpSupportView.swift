//
//  HelpSupportView.swift
//  Spark
//
//  Help & Support view with FAQ and feedback functionality
//

import SwiftUI

// MARK: - Help & Support View
struct HelpSupportView: View {
    
    // MARK: - Properties
    @Binding var isPresented: Bool
    @Environment(\.colorScheme) var colorScheme
    @State private var feedbackText: String = ""
    @State private var showFeedbackAlert: Bool = false
    
    // MARK: - FAQ Data
    private let faqItems: [(question: String, answer: String)] = [
        ("How do I earn points?", "You earn points by completing assignments on time, attending classes, participating in activities, and maintaining study streaks. The more consistent you are, the more points you accumulate!"),
        ("How to submit homework?", "Navigate to the Classes tab, select your class, find the assignment, and tap 'Submit'. You can attach files, photos, or type your response directly."),
        ("What are Spark Streaks?", "Spark Streaks track your consecutive days of productivity. Log in daily, complete tasks, and maintain your streak to earn bonus points and unlock achievements."),
        ("How do I sync my calendar?", "Go to Settings > Integrations and enable 'Sync Calendar'. Your assignments and exams will automatically appear in your device's calendar app."),
        ("Can I change my notification preferences?", "Yes! Go to Notifications from the side menu to customize which alerts you receive, including assignment reminders and daily briefings.")
    ]
    
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
                        // FAQ Section
                        faqSection
                        
                        // Feedback Section
                        feedbackSection
                        
                        // Bottom spacing
                        Color.clear.frame(height: 40)
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 16)
                }
            }
        }
        .alert("Feedback Sent", isPresented: $showFeedbackAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("Thank you for your feedback! We appreciate your input.")
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
            Text("Help & Support")
                .font(.system(size: 32, weight: .bold))
                .foregroundStyle(.white)
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
    }
    
    // MARK: - FAQ Section
    private var faqSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("FREQUENTLY ASKED QUESTIONS")
                .font(.system(size: 12, weight: .semibold))
                .foregroundStyle(.white.opacity(0.7))
                .padding(.leading, 4)
            
            VStack(spacing: 0) {
                ForEach(Array(faqItems.enumerated()), id: \.offset) { index, item in
                    FAQDisclosureRow(question: item.question, answer: item.answer)
                    
                    if index < faqItems.count - 1 {
                        Divider()
                            .background(Color.white.opacity(0.1))
                    }
                }
            }
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(colorScheme == .dark ? Color.white.opacity(0.08) : Color.white.opacity(0.2))
            )
        }
    }
    
    // MARK: - Feedback Section
    private var feedbackSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("SEND FEEDBACK")
                .font(.system(size: 12, weight: .semibold))
                .foregroundStyle(.white.opacity(0.7))
                .padding(.leading, 4)
            
            VStack(spacing: 16) {
                // Feedback Header
                HStack(spacing: 12) {
                    Image(systemName: "envelope.fill")
                        .font(.system(size: 24))
                        .foregroundStyle(.green)
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text("We'd love to hear from you!")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundStyle(.white)
                        
                        Text("Share your thoughts, suggestions, or report issues")
                            .font(.system(size: 12))
                            .foregroundStyle(.white.opacity(0.7))
                    }
                    
                    Spacer()
                }
                
                // Text Editor
                TextEditor(text: $feedbackText)
                    .frame(minHeight: 120)
                    .padding(12)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(colorScheme == .dark ? Color.black.opacity(0.3) : Color.white.opacity(0.3))
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.white.opacity(0.2), lineWidth: 1)
                    )
                    .scrollContentBackground(.hidden)
                    .foregroundStyle(.white)
                
                // Send Button
                Button(action: {
                    if !feedbackText.isEmpty {
                        showFeedbackAlert = true
                        feedbackText = ""
                    }
                }) {
                    HStack(spacing: 8) {
                        Image(systemName: "paperplane.fill")
                            .font(.system(size: 16))
                        Text("Send Feedback")
                            .font(.system(size: 16, weight: .semibold))
                    }
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(
                        RoundedRectangle(cornerRadius: 14)
                            .fill(
                                LinearGradient(
                                    colors: [Color.green, Color.green.opacity(0.8)],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                    )
                }
                .disabled(feedbackText.isEmpty)
                .opacity(feedbackText.isEmpty ? 0.6 : 1.0)
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(colorScheme == .dark ? Color.white.opacity(0.08) : Color.white.opacity(0.2))
            )
        }
    }
}

// MARK: - FAQ Disclosure Row
struct FAQDisclosureRow: View {
    let question: String
    let answer: String
    @State private var isExpanded: Bool = false
    
    var body: some View {
        DisclosureGroup(isExpanded: $isExpanded) {
            Text(answer)
                .font(.system(size: 14))
                .foregroundStyle(.white.opacity(0.8))
                .padding(.top, 8)
                .padding(.bottom, 4)
        } label: {
            HStack(spacing: 12) {
                Image(systemName: "questionmark.circle.fill")
                    .font(.system(size: 18))
                    .foregroundStyle(.cyan)
                
                Text(question)
                    .font(.system(size: 15, weight: .medium))
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.leading)
            }
        }
        .padding(14)
        .tint(.white)
    }
}

// MARK: - Preview
#Preview {
    HelpSupportView(isPresented: .constant(true))
}
