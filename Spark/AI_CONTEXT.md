# SPARK APP - AI CONTEXT & ARCHITECTURE

## 1. Project Overview
* **App Name:** Spark
* **Purpose:** Student productivity and notification system (iOS).
* **Target Audience:** University students (Features: Assignments, Classes, Calendar, Rewards).
* **Tech Stack:** Swift 5, SwiftUI, iOS 16+.
* **Data Flow:** MVVM pattern using a Singleton `AppState.shared` for global data.

## 2. Core Architecture (CRITICAL)
**Do NOT use standard `NavigationLink` for top-level navigation.**
* **Navigation Pattern:** The app uses a single `ContentView` with a `ZStack`.
* **Tab Navigation:** Standard `TabView` is used for the bottom bar (Home, Updates, Classes, Chats, Calendar).
* **Page Navigation:** Secondary pages (Side Menu, Profile, Rewards, Settings) are implemented as **Full-Screen Overlays** inside the ZStack.
    * *Mechanism:* They are conditionally rendered based on `@State` booleans (e.g., `if showProfilePage { ... }`).
    * *Transition:* `.transition(.move(edge: .trailing))`
    * *Dismissal:* Pages must have a custom "Back" button that toggles the boolean to `false`.

## 3. Design System & UI
* **Theme:** "Glassmorphism" with gradient backgrounds.
* **Colors (Role Based):**
    * 🔵 **Student Context:** Blue/Purple Gradients.
    * 🟢 **Lecturer Context:** Green/Teal Gradients (used for Teacher avatars/messages).
    * 🔴 **Urgent/Deadlines:** Red.
* **Components:**
    * `SparkBackground()`: Must be the bottom layer of every top-level view.
    * `SparkTabBar`: Custom floating tab bar at the bottom.
    * `SideMenuView`: Custom drawer sliding from the leading edge.

## 4. Data Models (AppState)
The app relies on `AppState.shared` (Singleton) for data.
* `currentUser`: Stores `SparkUser` (points, streak, program info).
* `assignments`: Array of `Assignment` (status: pending, submitted, graded).
* `calendarEvents`: Array of `CalendarEventItem`.
* `notifications`: Array of `NotifItem` (updates view).

## 5. Coding Guidelines for AI
1.  **Icons:** Always use SF Symbols.
2.  **Gradients:** Use `LinearGradient` for card backgrounds to match the "Spark" aesthetic.
3.  **Dates:** Use `DateFormatter` relative dating (e.g., "Today", "2 hours ago") for timestamps.
4.  **Mock Data:** When creating new views, always include a `#Preview` with dummy data.
5.  **Safety:** Use `if let` or `guard let` for optional unwrapping; avoid force unwrapping `!`.

## 6. Directory Structure Map
* `App/`: `SparkApp.swift`, `ContentView.swift`
* `Core/`: `AppState.swift` (Global State)
* `Models/`: `AppModels.swift` (Structs for User, Assignment, Course)
* `Views/Main/`: `HomeView`, `UpdatesView`, `ClassesView`
* `Views/Overlays/`: `SideMenuView`, `ProfileView`, `RewardsView`
* `Components/`: `Components.swift` (Reusable buttons, cards, headers)
