//
//  AboutView.swift
//  Spark
//
//  About view displaying app information and credits
//

import SwiftUI

// MARK: - About View
struct AboutView: View {
    
    // MARK: - Properties
    @Binding var isPresented: Bool
    @Environment(\.colorScheme) var colorScheme
    
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
                    VStack(spacing: 24) {
                        Spacer().frame(height: 40)
                        
                        // App Logo
                        appLogoSection
                        
                        // App Info
                        appInfoSection
                        
                        // Credits
                        creditsSection
                        
                        // Links Section
                        linksSection
                        
                        // Bottom spacing
                        Color.clear.frame(height: 40)
                    }
                    .padding(.horizontal, 16)
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
            Text("About")
                .font(.system(size: 32, weight: .bold))
                .foregroundStyle(.white)
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
    }
    
    // MARK: - App Logo Section
    private var appLogoSection: some View {
        VStack(spacing: 16) {
            // App Icon
            ZStack {
                RoundedRectangle(cornerRadius: 28)
                    .fill(
                        LinearGradient(
                            colors: [Color.orange, Color.red],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 120, height: 120)
                    .shadow(color: .orange.opacity(0.5), radius: 20, x: 0, y: 10)
                
                Image(systemName: "sparkles")
                    .font(.system(size: 50, weight: .bold))
                    .foregroundStyle(.white)
            }
            
            // App Name
            Text("Spark")
                .font(.system(size: 36, weight: .bold))
                .foregroundStyle(.white)
            
            // Tagline
            Text("Ignite Your Productivity")
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(.white.opacity(0.8))
        }
    }
    
    // MARK: - App Info Section
    private var appInfoSection: some View {
        VStack(spacing: 12) {
            AboutInfoRow(label: "Version", value: "1.0.0")
            AboutInfoRow(label: "Build", value: "2025.12.25")
            AboutInfoRow(label: "Platform", value: "iOS 17.0+")
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(colorScheme == .dark ? Color.white.opacity(0.08) : Color.white.opacity(0.2))
        )
    }
    
    // MARK: - Credits Section
    private var creditsSection: some View {
        VStack(spacing: 16) {
            // Made with love
            HStack(spacing: 8) {
                Text("Made with")
                    .font(.system(size: 16))
                    .foregroundStyle(.white.opacity(0.8))
                
                Image(systemName: "heart.fill")
                    .font(.system(size: 18))
                    .foregroundStyle(.red)
                
                Text("by Spark Team")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(.white)
            }
            
            // Team description
            Text("We're passionate about helping students succeed. Our mission is to create tools that make learning enjoyable and productive.")
                .font(.system(size: 14))
                .foregroundStyle(.white.opacity(0.7))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 20)
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(colorScheme == .dark ? Color.white.opacity(0.08) : Color.white.opacity(0.2))
        )
    }
    
    // MARK: - Links Section
    private var linksSection: some View {
        VStack(spacing: 0) {
            LinkRow(icon: "globe", title: "Website", color: .blue)
            Divider().background(Color.white.opacity(0.1))
            LinkRow(icon: "doc.text", title: "Privacy Policy", color: .gray)
            Divider().background(Color.white.opacity(0.1))
            LinkRow(icon: "doc.plaintext", title: "Terms of Service", color: .gray)
            Divider().background(Color.white.opacity(0.1))
            LinkRow(icon: "star.fill", title: "Rate on App Store", color: .yellow)
        }
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(colorScheme == .dark ? Color.white.opacity(0.08) : Color.white.opacity(0.2))
        )
    }
}

// MARK: - About Info Row
struct AboutInfoRow: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Text(label)
                .font(.system(size: 15))
                .foregroundStyle(.white.opacity(0.7))
            
            Spacer()
            
            Text(value)
                .font(.system(size: 15, weight: .medium))
                .foregroundStyle(.white)
        }
    }
}

// MARK: - Link Row
struct LinkRow: View {
    let icon: String
    let title: String
    let color: Color
    
    var body: some View {
        Button(action: {
            // Handle link action
        }) {
            HStack(spacing: 14) {
                Image(systemName: icon)
                    .font(.system(size: 18))
                    .foregroundStyle(color)
                    .frame(width: 36, height: 36)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(color.opacity(0.15))
                    )
                
                Text(title)
                    .font(.system(size: 15, weight: .medium))
                    .foregroundStyle(.white)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundStyle(.white.opacity(0.4))
            }
            .padding(14)
        }
    }
}

// MARK: - Preview
#Preview {
    AboutView(isPresented: .constant(true))
}
